class ActivityLog < ApplicationRecord
  belongs_to :loggable, polymorphic: true
  belongs_to :user, optional: true
  belongs_to :account
  
  enum action: { 
    created: 'created', 
    updated: 'updated', 
    deleted: 'deleted', 
    viewed: 'viewed', 
    exported: 'exported' 
  }
  
  validates :action, presence: true
  validates :description, presence: true
  
  # Map actions to icons
  def icon_class
    case action
    when :created then 'fa-plus-circle'
    when :updated then 'fa-edit'
    when :deleted then 'fa-trash'
    when :viewed then 'fa-eye'
    when :exported then 'fa-download'
    else 'fa-circle'
    end
  end
end

