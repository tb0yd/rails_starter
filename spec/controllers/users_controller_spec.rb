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
      expect(assigns(:users)).to match_array(users)
    end
  end
  
  describe "GET #show" do
    let(:target_user) { create(:user) }
    
    before do
      create(:account_user, user: target_user, account: account)
    end
    
    it "returns a success response" do
      get :show, params: { id: target_user.id }
      expect(response).to be_successful
    end
    
    it "assigns the requested user as @user" do
      get :show, params: { id: target_user.id }
      expect(assigns(:user)).to eq(target_user)
    end
    
    it "logs the activity" do
      expect {
        get :show, params: { id: target_user.id }
      }.to change(ActivityLog, :count).by(1)
      
      log = ActivityLog.last
      expect(log.action).to eq('viewed')
      expect(log.loggable).to eq(target_user)
    end
  end
end

