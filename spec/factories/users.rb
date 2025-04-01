FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    
    # Don't set password_confirmation directly since our User model doesn't have this attribute
    active { true }
    
    trait :inactive do
      active { false }
    end
    
    trait :with_account do
      after(:create) do |user|
        account = create(:account)
        create(:account_user, user: user, account: account, role: 'adm')
      end
    end
  end
end

