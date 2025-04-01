namespace :data do
  desc "Export data for a specific account"
  task :export, [:user_id, :account_id, :export_type] => :environment do |t, args|
    user_id = args[:user_id]
    account_id = args[:account_id]
    export_type = args[:export_type] || 'users'
    
    puts "Queueing #{export_type} export for account #{account_id}"
    
    # Create export record
    export = DataExport.create!(
      user_id: user_id,
      account_id: account_id,
      export_type: export_type,
      status: 'pending'
    )
    
    # Queue worker
    Resque.enqueue(
      DataExportWorker, 
      user_id, 
      account_id, 
      export_type, 
      { start_date: 30.days.ago }
    )
    
    puts "Export queued with ID: #{export.id}"
  end
end

