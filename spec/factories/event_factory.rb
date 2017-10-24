FactoryGirl.define do

  factory :event do
    name 'My Birthday Party'
    location 'Amirandes Grecotel Exclusive Resort'
    starting '2017-10-17'
    ending '2017-10-22'
    description <<-DESC
# Pool Party for my Birthday

Make sure you bring a gift.

[I will be there](https://www.rsvp.com)
    DESC
  end
end
