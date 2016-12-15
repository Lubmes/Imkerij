FactoryGirl.define do
  factory :event do
    name 'Honing centrifugeren'
    description 'Zie hoe uit de raten honing wordt getrokken.'
    date 14.days.from_now
  end
end