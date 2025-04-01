require 'rails_helper'

RSpec.feature "User Management", type: :feature do
  let(:user) { create(:user, :with_account) }
  
  before do
    # Log in
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Login"
  end
  
  scenario "User views the list of users" do
    visit users_path
    
    expect(page).to have_content("Users")
    expect(page).to have_content(user.email)
  end
  
  scenario "User creates a new user" do
    visit new_user_path
    
    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    select "Member", from: "Role"
    
    click_button "Create User"
    
    expect(page).to have_content("User was successfully created")
    expect(page).to have_content("newuser@example.com")
  end
end

