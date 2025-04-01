class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  acts_as_paranoid
  
  def self.current_account_id
    Thread.current[:current_account_id]
  end
  
  def self.current_user_id
    Thread.current[:current_user_id]
  end
end

