require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  let(:user) { create(:user, :with_account) }
  let(:user_session) { double(destroy: true) }
  
  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(UserSession).to receive(:find).and_return(user_session)
  end
  
  describe 'DELETE #destroy' do
    it 'destroys the current user session' do
      expect(user_session).to receive(:destroy)
      delete :destroy
    end
    
    it 'sets a flash notice' do
      delete :destroy
      expect(flash[:notice]).to eq('Logout successful!')
    end
    
    it 'redirects to the login page' do
      delete :destroy
      expect(response).to redirect_to(login_url)
    end
  end
end 