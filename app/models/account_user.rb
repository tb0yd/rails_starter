class AccountUser < ApplicationRecord
  belongs_to :account
  belongs_to :user
  
  # Enum for role (using strings as per guide)
  enum role: { admin: 'adm', member: 'mem', viewer: 'vwr' }
  
  validates :account_id, presence: true
  validates :user_id, presence: true
  validates :role, presence: true
end

