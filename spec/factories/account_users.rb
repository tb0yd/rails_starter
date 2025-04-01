FactoryBot.define do
  factory :account_user do
    association :user
    association :account
    role { 'mem' }
    
    trait :admin do
      role { 'adm' }
    end
    
    trait :viewer do
      role { 'vwr' }
    end
  end
end

