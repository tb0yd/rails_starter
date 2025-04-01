class Account < ApplicationRecord
  has_many :account_users
  has_many :users, through: :account_users
  
  validates :name, presence: { message: "Account Name can't be blank" }
  
  scope :active, -> { where(active: true) }
  
  attr_accessor :setup_complete
  
  after_create :setup_default_settings
  
  private
  
  def setup_default_settings
    # Initialize any default settings for a new account
    # This is a placeholder for future implementation
    self.setup_complete = true
  end
end

