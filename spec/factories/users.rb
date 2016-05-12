FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  sequence :username do |n|
    "username#{n}"
  end

  factory :user do
    email
    username
    password "12345678"
    password_confirmation "12345678"
  end

  factory :invalid_user, class: "User" do
    name nil
  end
end
