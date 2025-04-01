class Account < ApplicationRecord
  has_many :account_users
  has_many :users, through: :account_users
  
  validates :name, presence: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  
  # Virtual attributes
  attr_accessor :setup_complete
  
  # Lifecycle callbacks
  after_create :setup_default_settings
  
  private
  
  def setup_default_settings
    # Initialize default settings for new accounts
    # This would be implemented based on specific requirements
  end
end

