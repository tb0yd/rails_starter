require 'rails_helper'
require 'rake'

RSpec.describe "data:export", type: :task do
  before do
    Rails.application.load_tasks
  end
  
  it "preloads the Rails environment" do
    expect(Rake::Task['data:export'].prerequisites).to include("environment")
  end
  
  it "queues a data export job" do
    user = create(:user)
    account = create(:account)
    
    expect(Resque).to receive(:enqueue).with(
      DataExportWorker, 
      user.id, 
      account.id, 
      'users', 
      hash_including(start_date: anything)
    )
    
    Rake::Task['data:export'].invoke(user.id, account.id, 'users')
  end
end

