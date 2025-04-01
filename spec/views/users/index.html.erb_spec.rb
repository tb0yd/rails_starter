require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before do
    assign(:users, [
      create(:user, email: "user1@example.com"),
      create(:user, email: "user2@example.com")
    ])
  end
  
  it "renders a list of users" do
    render
    
    expect(rendered).to match(/user1@example.com/)
    expect(rendered).to match(/user2@example.com/)
  end
  
  it "renders the new user link" do
    render
    
    expect(rendered).to have_link("New User", href: new_user_path)
  end
end

