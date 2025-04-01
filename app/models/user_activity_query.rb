class UserActivityQuery
  include ActiveModel::Model
  
  attr_accessor :account_id, :user_id, :start_date, :end_date
  
  def execute
    sanitized_query = ActiveRecord::Base.sanitize_sql([query, 
      account_id: account_id,
      user_id: user_id,
      start_date: start_date || 30.days.ago,
      end_date: end_date || Time.current
    ])
    
    result = ActiveRecord::Base.connection.execute(sanitized_query)
    result.to_a.map(&:with_indifferent_access)
  end
  
  private
  
  def query
    <<-SQL
      SELECT 
        u.id as user_id,
        u.email,
        COUNT(al.id) as activity_count,
        MAX(al.created_at) as last_activity_at
      FROM users u
      LEFT JOIN activity_logs al ON al.user_id = u.id
      WHERE u.account_id = :account_id
        AND (:user_id IS NULL OR u.id = :user_id)
        AND al.created_at BETWEEN :start_date AND :end_date
      GROUP BY u.id, u.email
      ORDER BY activity_count DESC, last_activity_at DESC
    SQL
  end
end

