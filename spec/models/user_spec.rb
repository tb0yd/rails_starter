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

  describe "temporary password generation" do
    it "generates a strong temporary password" do
      user = User.new(email: "test@example.com")
      password = user.generate_temporary_password
      
      expect(password).to match(/[A-Z]/) # Contains uppercase
      expect(password).to match(/[a-z]/) # Contains lowercase
      expect(password).to match(/[0-9]/) # Contains number
      expect(password).to match(/[^A-Za-z0-9]/) # Contains special char
      expect(password.length).to eq(16) # Is 16 characters long
    end

    it "sets the generated password" do
      user = User.new(email: "test@example.com")
      password = user.generate_temporary_password
      
      expect(user.password).to eq(password)
    end

    it "generates unique passwords" do
      user = User.new(email: "test@example.com")
      password1 = user.generate_temporary_password
      password2 = user.generate_temporary_password
      
      expect(password1).not_to eq(password2)
    end
  end
end

