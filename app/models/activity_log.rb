class ActivityLog < ApplicationRecord
  belongs_to :loggable, polymorphic: true
  belongs_to :user, optional: true
  belongs_to :account
  
  enum action: { 
    created: 'crt', 
    updated: 'upd', 
    deleted: 'del', 
    viewed: 'viw', 
    exported: 'exp' 
  }
  
  validates :action, presence: true
  validates :description, presence: true
  
  # Map actions to icons
  def icon_class
    case action
    when 'crt' then 'fa-plus-circle'
    when 'upd' then 'fa-edit'
    when 'del' then 'fa-trash'
    when 'viw' then 'fa-eye'
    when 'exp' then 'fa-download'
    else 'fa-circle'
    end
  end
end

