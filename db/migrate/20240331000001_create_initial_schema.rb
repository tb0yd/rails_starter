class CreateInitialSchema < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.boolean :active, default: true
      t.timestamps
      t.datetime :deleted_at, index: true
    end
    
    create_table :users do |t|
      # AuthLogic columns
      t.string :email, null: false
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :single_access_token
      t.string :perishable_token
      
      # Login tracking
      t.integer :login_count, default: 0, null: false
      t.integer :failed_login_count, default: 0, null: false
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      
      t.boolean :active, default: true
      t.timestamps
      t.datetime :deleted_at, index: true
    end
    
    add_index :users, :email, unique: true
    
    create_table :account_users do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, null: false, default: 'mem'
      t.timestamps
      t.datetime :deleted_at, index: true
    end
    
    add_index :account_users, [:account_id, :user_id], unique: true
    
    create_table :activity_logs do |t|
      t.references :loggable, polymorphic: true
      t.references :user, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :action, null: false
      t.string :description, null: false
      t.timestamps
    end
    
    create_table :twilio_requests do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :endpoint, null: false
      t.string :api_version, null: false
      t.text :request_body, null: false
      t.timestamps
    end
    
    create_table :twilio_responses do |t|
      t.references :twilio_request, null: false, foreign_key: true
      t.integer :http_status
      t.text :response_body, null: false
      t.string :message_sid
      t.string :call_sid
      t.string :verification_sid
      t.string :status
      t.timestamps
    end
    
    create_table :data_exports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :export_type, null: false
      t.string :status, null: false, default: 'pending'
      t.text :file_data
      t.text :error_message
      t.datetime :started_at
      t.datetime :completed_at
      t.timestamps
    end
  end
end

