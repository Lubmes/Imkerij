FactoryGirl.define do
  factory :user, aliases: [:customer] do
    sequence(:email) { |n| "test#{n}@example.com" }
    password 'password'
    firstname 'Piet' 
    lastname 'Hein'
    street 'Dorpstraat'
    number '12'
    postcode '1234AB'
    city 'Ons Dorp'
    country 'United States'

    trait :admin do
      admin true
    end
  end
end