require 'rails_helper'

RSpec.describe UserActivityQuery, type: :model do
  let(:account) { create(:account) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  
  before do
    # Create account users
    create(:account_user, account: account, user: user1)
    create(:account_user, account: account, user: user2)
    create(:account_user, account: account, user: user3)
    
    # Create activity logs for different users
    create_list(:activity_log, 3, account: account, user: user1, created_at: 2.days.ago)
    create_list(:activity_log, 2, account: account, user: user2, created_at: 1.day.ago)
    create_list(:activity_log, 1, account: account, user: user3, created_at: 3.days.ago)
  end
  
  describe "initialization" do
    it "accepts account_id, start_date, and end_date parameters" do
      start_date = 1.week.ago
      end_date = Time.current
      
      query = described_class.new(
        account_id: 1,
        start_date: start_date,
        end_date: end_date
      )
      
      expect(query.account_id).to eq(1)
      expect(query.start_date).to be_within(1.second).of(start_date)
      expect(query.end_date).to be_within(1.second).of(end_date)
    end
    
    it "sets default dates if not provided" do
      query = described_class.new(account_id: 1)
      
      expect(query.start_date).to be_within(1.second).of(30.days.ago)
      expect(query.end_date).to be_within(1.second).of(Time.current)
    end
  end
  
  describe "#execute" do
    let(:query) { described_class.new(account_id: account.id) }
    
    it "returns activity data for all users in the account" do
      results = query.execute
      
      expect(results.length).to eq(3)
      expect(results.map { |r| r[:user_id] }).to match_array([user1.id, user2.id, user3.id])
    end
    
    it "orders results by activity count and last activity" do
      results = query.execute
      
      expect(results[0][:user_id]).to eq(user1.id)
      expect(results[1][:user_id]).to eq(user2.id)
      expect(results[2][:user_id]).to eq(user3.id)
    end
    
    it "includes correct activity counts" do
      results = query.execute
      
      expect(results.find { |r| r[:user_id] == user1.id }[:activity_count]).to eq(3)
      expect(results.find { |r| r[:user_id] == user2.id }[:activity_count]).to eq(2)
      expect(results.find { |r| r[:user_id] == user3.id }[:activity_count]).to eq(1)
    end
    
    context "when querying with date range" do
      let(:query) do
        described_class.new(
          account_id: account.id,
          start_date: 2.days.ago,
          end_date: 1.day.ago
        )
      end
      
      it "returns only activities within the date range" do
        results = query.execute
        
        expect(results.length).to eq(2)
        expect(results.map { |r| r[:user_id] }).to match_array([user1.id, user2.id])
      end
    end
    
    context "when querying with no activities" do
      let(:empty_account) { create(:account) }
      let(:query) { described_class.new(account_id: empty_account.id) }
      
      it "returns an empty array" do
        expect(query.execute).to be_empty
      end
    end
  end
end 