class User < ApplicationRecord
  has_many :account_users
  has_many :accounts, through: :account_users
  
  # AuthLogic configuration
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::SCrypt
  end
  
  # Scopes
  scope :active, -> { where(active: true) }
  
  # Virtual attributes
  attr_accessor :current_login
  
  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: :password_required?
  
  private
  
  def password_required?
    new_record? || !password.nil? || !password_confirmation.nil?
  end
end

