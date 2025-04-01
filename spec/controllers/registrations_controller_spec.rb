require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'GET #new' do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new user as @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          user: {
            email: "newuser@example.com",
            password: "password123",
            accounts_attributes: [
              { name: "New Account" }
            ]
          }
        }
      end

      it "creates a new user" do
        expect {
          post :create, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "creates a new account" do
        expect {
          post :create, params: valid_attributes
        }.to change(Account, :count).by(1)
      end

      it "creates an admin account_user association" do
        post :create, params: valid_attributes
        
        # Verify the account_user association has admin role
        user = User.find_by(email: "newuser@example.com")
        account = Account.find_by(name: "New Account")
        account_user = AccountUser.find_by(user: user, account: account)
        
        expect(account_user).to be_present
        expect(account_user.role).to eq('adm')
      end

      it "logs in the user automatically" do
        post :create, params: valid_attributes
        expect(UserSession.find).not_to be_nil
        expect(UserSession.find.user.email).to eq("newuser@example.com")
      end

      it "redirects to the dashboard" do
        post :create, params: valid_attributes
        expect(response).to redirect_to(dashboard_path)
      end

      it "creates an activity log" do
        expect {
          post :create, params: valid_attributes
        }.to change(ActivityLog, :count).by(1)

        activity_log = ActivityLog.last
        expect(activity_log.loggable).to eq(User.last)
        expect(activity_log.user).to eq(User.last)
        expect(activity_log.account).to eq(Account.last)
        expect(activity_log.action).to eq('created')
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          user: {
            email: "invalid-email",
            password: "short",
            accounts_attributes: [
              { name: "" }
            ]
          }
        }
      end

      it "does not create a new user" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(User, :count)
      end

      it "does not create a new account" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Account, :count)
      end

      it "renders the new template" do
        post :create, params: invalid_attributes
        expect(response).to render_template(:new)
      end

      it "assigns user with errors" do
        post :create, params: invalid_attributes
        expect(assigns(:user).errors).not_to be_empty
      end

      it "does not create an activity log" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(ActivityLog, :count)
      end
    end
  end
end 