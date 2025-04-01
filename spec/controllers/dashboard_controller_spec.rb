require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:account) { create(:account) }
  let(:user) { create(:user, :with_account) }
  
  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_account).and_return(account)
    session[:current_account_id] = account.id
    
    # Mock the view rendering to avoid asset pipeline issues in tests
    allow(controller).to receive(:render).and_return("Dashboard rendered")
  end
  
  describe "GET #index" do
    before do
      # Create some activity logs for testing
      create_list(:activity_log, 3, account: account, user: user)
    end
    
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
    
    it "assigns the correct data for the dashboard" do
      get :index
      expect(assigns(:recent_activities)).to be_a(ActiveRecord::Relation)
      expect(assigns(:recent_activities).count).to eq(3)
    end
  end
end 