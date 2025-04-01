FactoryBot.define do
  factory :activity_log do
    association :account
    association :user
    association :loggable, factory: :user
    action { 'viewed' }
    description { 'Viewed the dashboard' }
  end
end 