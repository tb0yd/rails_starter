require 'rails_helper'

RSpec.feature "Authentication", type: :feature do
  let(:user) { create(:user, :with_account) }
  
  before do
    # Log in
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Login"
    
    # Verify we're logged in
    expect(page).to have_content("Dashboard")
  end
  
  scenario "User can log out" do
    # Verify we're logged in
    expect(page).to have_content("Logout")
    
    # Click logout
    click_link "Logout"
    
    # Verify we're logged out
    expect(page).to have_content("Login")
    expect(page).to have_content("Logout successful!")
    
    # Verify we can't access protected pages
    visit dashboard_path
    expect(page).to have_content("You must be logged in to access this page")
  end
end 