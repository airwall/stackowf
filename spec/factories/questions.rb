FactoryGirl.define do
  sequence :title do |n|
  "Question #{n}"
  end

  factory :question do
    title
    body "MyBodyOfQuestion"
    after(:create) do |question|
      FactoryGirl.create(:answer, question: question)
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
