require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before do
    @account = create(:account)
    @user1 = create(:user, email: "user1@example.com")
    @user2 = create(:user, email: "user2@example.com")
    
    create(:account_user, account: @account, user: @user1, role: 'adm')
    create(:account_user, account: @account, user: @user2, role: 'mem')
    
    assign(:users, [@user1, @user2])
    assign(:current_account, @account)
    
    # Make current_account available to the view
    def view.current_account
      @current_account
    end
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

