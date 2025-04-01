class AccountUser < ApplicationRecord
  belongs_to :account
  belongs_to :user
  
  # Define roles using string values
  ROLES = {
    'adm' => 'Admin',
    'mem' => 'Member',
    'vwr' => 'Viewer'
  }.freeze
  
  validates :account_id, presence: true
  validates :user_id, presence: true
  validates :role, presence: true, inclusion: { in: ROLES.keys }
end

