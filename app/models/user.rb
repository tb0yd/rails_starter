class User < ApplicationRecord
  has_many :account_users
  has_many :accounts, through: :account_users
  accepts_nested_attributes_for :accounts
  
  # AuthLogic configuration
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::SCrypt
    c.require_password_confirmation = false
  end
  
  # Scopes
  scope :active, -> { where(active: true) }
  
  # Virtual attributes
  attr_accessor :current_login
  
  # Validations
  validates :email, presence: true, 
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }
  validates :password, presence: true, if: :password_required?
  validates_associated :accounts
  
  def generate_temporary_password
    # Generate a strong password with:
    # - 4 uppercase letters
    # - 4 lowercase letters
    # - 4 numbers
    # - 4 special characters
    # Total length: 16 characters
    password = [
      ('A'..'Z').to_a.sample(4),
      ('a'..'z').to_a.sample(4),
      ('0'..'9').to_a.sample(4),
      ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '+', '=', '[', ']', '{', '}', '|', '\\', ';', ':', '"', "'", '<', '>', ',', '.', '?', '/'].sample(4)
    ].flatten.shuffle.join
    
    self.password = password
    password
  end
  
  private
  
  def password_required?
    new_record? || !password.nil?
  end
end

