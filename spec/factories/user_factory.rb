FactoryGirl.define do
  factory :user, aliases: [:customer] do
    sequence(:email) { |n| "test#{n}@example.com" }
    password 'password'
    first_name 'Piet'
    last_name 'Hein'

    trait :admin do
      admin true
    end
  end
end
