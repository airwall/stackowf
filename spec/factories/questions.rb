FactoryGirl.define do
  sequence :title do |n|
    "Question #{n}"
  end

  factory :question do
    user
    title
    body "MyBodyOfQuestion"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
