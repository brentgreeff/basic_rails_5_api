FactoryGirl.define do

  factory :user do
    full_name 'kurt russell'
    email 'kurt@example.com'
    password 'password'

    factory :organiser do
      full_name 'Carl Cox'
      email 'carl@example.com'
      password 'techno'
    end

    factory :someone_else do
      full_name 'Someone Else'
      email 'someone@example.com'
      password 'strange'
    end

    factory :guest do
      full_name 'Invited Person'
      email { "invited#{User.count}@example.com" }
    end
  end
end
