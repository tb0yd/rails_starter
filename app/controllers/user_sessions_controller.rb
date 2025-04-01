class UserSessionsController < ApplicationController
  skip_before_action :require_user, only: [:new, :create]
  before_action :require_no_user, only: [:new, :create]
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(user_session_params)
    
    respond_to do |format|
      if @user_session.save
        format.html { redirect_back_or_default(dashboard_url) }
        format.turbo_stream { redirect_back_or_default(dashboard_url) }
      else
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('login_form', partial: 'user_sessions/form', locals: { user_session: @user_session }) }
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_url
  end
  
  private
  
  def user_session_params
    params.require(:user_session).permit(:email, :password, :remember_me)
  end
end

