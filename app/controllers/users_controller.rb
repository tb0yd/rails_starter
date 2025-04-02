class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = current_account.users
  end
  
  def show
    # Log activity
    ActivityLog.create!(
      loggable: @user,
      user: current_user,
      account: current_account,
      action: :viewed,
      description: "Viewed user #{@user.email}"
    )
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  def create
    @user = User.new(user_params)
    @user.generate_temporary_password
    
    if @user.save
      # Create account user association
      AccountUser.create!(
        user: @user,
        account: current_account,
        role: params[:role] || 'mem'
      )
      
      # Log activity
      ActivityLog.create!(
        loggable: @user,
        user: current_user,
        account: current_account,
        action: :created,
        description: "Created user #{@user.email}"
      )
      
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end
  
  def update
    if @user.update(user_params)
      # Log activity
      ActivityLog.create!(
        loggable: @user,
        user: current_user,
        account: current_account,
        action: :updated,
        description: "Updated user #{@user.email}"
      )
      
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    # Log activity before destroy
    ActivityLog.create!(
      loggable: @user,
      user: current_user,
      account: current_account,
      action: :deleted,
      description: "Deleted user #{@user.email}"
    )
    
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end
  
  private
  
  def set_user
    @user = current_account.users.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:email, :active)
  end
end

