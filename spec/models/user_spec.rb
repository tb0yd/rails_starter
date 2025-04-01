require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it "has many account_users" do
      user = User.new
      expect(user.account_users).to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
    end
    
    it "has many accounts through account_users" do
      user = User.new
      expect(user.accounts).to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
    end
  end
  
  describe "validations" do
    it "requires an email" do
      user = User.new
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end
    
    it "requires a unique email" do
      existing_user = create(:user, email: "test@example.com")
      user = User.new(email: "test@example.com")
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
    end
    
    it "requires a password for new records" do
      user = User.new
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end
  end
  
  describe "scopes" do
    it "active returns only active users" do
      active_user = create(:user, active: true)
      inactive_user = create(:user, active: false)
      
      expect(User.active).to include(active_user)
      expect(User.active).not_to include(inactive_user)
    end
  end
end

