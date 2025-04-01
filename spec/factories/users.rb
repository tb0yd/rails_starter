FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    active { true }
    
    trait :inactive do
      active { false }
    end
    
    trait :with_account do
      after(:create) do |user|
        account = create(:account)
        create(:account_user, user: user, account: account, role: 'admin')
      end
    end
  end
end

