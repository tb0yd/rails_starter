class ApplicationController < ActionController::Base
  before_action :require_user
  around_action :scope_to_current_account
  
  helper_method :current_user, :current_account
  
  private
  
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
  def current_user
    @current_user ||= current_user_session&.user
  end
  
  def current_account
    @current_account ||= current_user&.accounts&.find_by(id: session[:current_account_id]) || current_user&.accounts&.first
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.original_url
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def scope_to_current_account
    if current_account
      Thread.current[:current_account_id] = current_account.id
      Thread.current[:current_user_id] = current_user.id
      
      # Use ActiveRecord's scoping to automatically filter by account
      Account.where(id: current_account.id).scoping do
        yield
      end
      
      # Clear thread locals after request
      Thread.current[:current_account_id] = nil
      Thread.current[:current_user_id] = nil
    else
      yield
    end
  end
end

