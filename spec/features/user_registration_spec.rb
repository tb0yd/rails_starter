require 'rails_helper'

RSpec.feature "User Registration", type: :feature do
  let(:account) { create(:account) }
  
  scenario "New user registers and creates a new account" do
    visit register_path
    
    # Fill in registration form
    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Account name", with: "New Test Account"
    
    click_button "Register"
    
    # Expectations after successful registration
    expect(page).to have_content("Registration successful! Welcome to the application.")
    expect(page).to have_current_path(dashboard_path)
    
    # Verify user and account were created
    user = User.find_by(email: "newuser@example.com")
    expect(user).to be_present
    expect(user.accounts.first.name).to eq("New Test Account")
  end
  
  scenario "User tries to register with invalid information" do
    visit register_path
    
    # Submit form with invalid data
    fill_in "Email", with: "invalid"
    fill_in "Password", with: "short"
    fill_in "Account name", with: ""
    
    click_button "Register"
    
    # Expectations after failed registration
    expect(page).to have_content("Account Name can't be blank")
  end
end 