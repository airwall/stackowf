FactoryGirl.define do
  sequence :title do |n|
  "Question #{n}"
  end

  factory :question do
    title
    body "MyBodyOfQuestion"
    transient do
      count 3
    end
    after(:create) do |question, i|
      FactoryGirl.create_list(:answer, i.count, question: question)
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
