FactoryBot.define do
  factory :account do
    sequence(:name) { |n| "Account #{n}" }
    active { true }
    
    trait :inactive do
      active { false }
    end
    
    trait :with_users do
      transient do
        users_count { 3 }
      end
      
      after(:create) do |account, evaluator|
        create_list(:user, evaluator.users_count).each do |user|
          create(:account_user, user: user, account: account)
        end
      end
    end
  end
end

