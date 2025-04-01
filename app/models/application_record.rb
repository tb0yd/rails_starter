class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Include Paranoia for soft deletion
  acts_as_paranoid
  
  # Thread-local variables for multitenancy
  def self.current_account_id
    Thread.current[:current_account_id]
  end
  
  def self.current_user_id
    Thread.current[:current_user_id]
  end
end

