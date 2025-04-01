class DataExportWorker
  include Resque::Plugins::Retry
  include Resque::Plugins::Timeout
  
  @queue = :exports
  @retry_limit = 3
  @retry_delay = 60
  @timeout = 300
  
  def self.perform(user_id, account_id, export_type, options = {})
    # Set thread locals for multitenancy
    Thread.current[:current_account_id] = account_id
    Thread.current[:current_user_id] = user_id
    
    # Guard against duplicate jobs
    export = DataExport.find_by(
      user_id: user_id,
      account_id: account_id,
      export_type: export_type,
      status: 'pending'
    )
    
    return if export.nil?
    
    # Mark as processing
    export.update!(status: 'processing', started_at: Time.current)
    
    begin
      # Generate export based on type
      case export_type
      when 'users'
        data = generate_users_export(account_id, options)
      when 'activity'
        data = generate_activity_export(account_id, options)
      else
        raise "Unknown export type: #{export_type}"
      end
      
      # Save export data
      export.update!(
        status: 'completed',
        completed_at: Time.current,
        file_data: data
      )
      
      # Log activity
      ActivityLog.create!(
        loggable: export,
        user_id: user_id,
        account_id: account_id,
        action: 'exported',
        description: "Exported #{export_type} data"
      )
    rescue => e
      # Handle failure
      export.update!(
        status: 'failed',
        error_message: e.message
      )
      
      # Re-raise to trigger retry
      raise e
    ensure
      # Clear thread locals
      Thread.current[:current_account_id] = nil
      Thread.current[:current_user_id] = nil
    end
  end
  
  def self.generate_users_export(account_id, options)
    # Implementation would go here
    # This is a placeholder
    "user1,user1@example.com\nuser2,user2@example.com"
  end
  
  def self.generate_activity_export(account_id, options)
    # Implementation would go here
    # This is a placeholder
    "action,user,timestamp\ncreated,user1,2023-01-01"
  end
end

