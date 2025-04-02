require 'rails_helper'

RSpec.feature "User Creation", type: :feature do
  let(:admin) { create(:user) }
  let(:account) { create(:account) }
  let!(:account_user) { create(:account_user, user: admin, account: account, role: 'adm') }
  
  before do
    # Log in as admin
    visit login_path
    fill_in "Email", with: admin.email
    fill_in "Password", with: "password123"
    click_button "Login"
  end
  
  scenario "Admin creates a new user with a temporary password" do
    visit new_user_path
    
    fill_in "Email", with: "newuser@example.com"
    select "Member", from: "Role"
    
    click_button "Create User"
    
    # Verify success message
    expect(page).to have_content("User was successfully created")
    expect(page).to have_content("newuser@example.com")
    
    # Verify user was created with correct role
    user = User.find_by(email: "newuser@example.com")
    expect(user).to be_present
    expect(user.account_users.first.role).to eq("mem")
    
    # Verify activity was logged
    log = ActivityLog.where(action: 'created', loggable: user).last
    expect(log).to be_present
    expect(log.action).to eq('created')
    expect(log.loggable).to eq(user)
    expect(log.user).to eq(admin)
    expect(log.account).to eq(account)
  end
  
  scenario "Admin cannot create a user with an invalid email" do
    visit new_user_path
    
    fill_in "Email", with: "invalid-email"
    select "Member", from: "Role"
    
    click_button "Create User"
    
    expect(page).to have_content("Email is invalid")
  end
  
  scenario "Admin cannot create a user with a duplicate email" do
    create(:account_user, user: admin, account: account)
    
    visit new_user_path
    
    fill_in "Email", with: admin.email
    select "Member", from: "Role"
    
    click_button "Create User"
    
    expect(page).to have_content("Email has already been taken")
  end
end 