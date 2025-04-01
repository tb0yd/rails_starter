class UserActivityQuery
  include ActiveModel::Model
  
  attr_accessor :account_id, :start_date, :end_date
  
  def initialize(attributes = {})
    super
    @start_date ||= 30.days.ago
    @end_date ||= Time.current
  end
  
  def execute
    sanitized_query = ActiveRecord::Base.sanitize_sql([query, 
      account_id: account_id,
      start_date: start_date.beginning_of_day,
      end_date: end_date.end_of_day
    ])
    
    result = ActiveRecord::Base.connection.execute(sanitized_query)
    result.to_a.map(&:with_indifferent_access)
  end
  
  private
  
  def query
    <<-SQL
      WITH filtered_activities AS (
        SELECT 
          u.id as user_id,
          u.email,
          COUNT(CASE WHEN al.created_at BETWEEN :start_date AND :end_date THEN al.id END) as activity_count,
          MAX(CASE WHEN al.created_at BETWEEN :start_date AND :end_date THEN al.created_at END) as last_activity_at
        FROM users u
        INNER JOIN account_users au ON au.user_id = u.id
        LEFT JOIN activity_logs al ON al.user_id = u.id
        WHERE au.account_id = :account_id
        GROUP BY u.id, u.email
      )
      SELECT *
      FROM filtered_activities
      WHERE activity_count > 0
      ORDER BY activity_count DESC, last_activity_at DESC
    SQL
  end
end

