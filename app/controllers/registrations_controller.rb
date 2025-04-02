class RegistrationsController < ApplicationController
  skip_before_action :require_user
  skip_around_action :scope_to_current_account
  before_action :require_no_user
  
  def new
    @user = User.new
    @user.accounts.build
  end
  
  def create
    @user = User.new(user_params)
    
    ActiveRecord::Base.transaction do  
      if @user.valid?
        @user.save!
        @account = @user.accounts.first
        
        # Update or create account_user association with admin role
        account_user = AccountUser.find_or_initialize_by(user: @user, account: @account)
        account_user.role = 'adm'
        account_user.save!
        
        # Log activity
        ActivityLog.create!(
          loggable: @user,
          user: @user,
          account: @account,
          action: :created,
          description: "User registered and created account #{@account.name}"
        )
        
        # Automatically log the user in
        UserSession.create!(@user)
        session[:current_account_id] = @account.id
        
        respond_to do |format|
          format.html do
            flash[:notice] = "Registration successful! Welcome to the application."
            redirect_to dashboard_path
          end
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("registration_form", partial: "registration_success")
          end
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("registration_form", partial: "registration_form", locals: { user: @user })
          end
        end
      end
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(
      :email, 
      :password, 
      :password_confirmation,
      accounts_attributes: [:name]
    )
  end
end 