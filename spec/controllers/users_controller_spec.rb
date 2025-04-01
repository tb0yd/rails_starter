require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:account) { create(:account) }
  let(:user) { create(:user, :with_account) }
  
  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_account).and_return(account)
    session[:current_account_id] = account.id
  end
  
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
    
    it "assigns @users" do
      users = create_list(:user, 3)
      users.each do |u|
        create(:account_user, user: u, account: account)
      end
      
      get :index
      expect(assigns(:users)).to match_array(users + [user])
    end
  end
  
  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end
    
    it "assigns the requested user as @user" do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
    
    it "logs the activity" do
      expect {
        get :show, params: { id: user.id }
      }.to change(ActivityLog, :count).by(1)
      
      log = ActivityLog.last
      expect(log.action).to eq('viewed')
      expect(log.loggable).to eq(user)
    end
  end
end

