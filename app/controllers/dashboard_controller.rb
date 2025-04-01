class DashboardController < ApplicationController
  def index
    # Fetch the data needed for the dashboard
    @recent_activities = ActivityLog.where(account: current_account).order(created_at: :desc).limit(5)
  end
end

