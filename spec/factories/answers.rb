FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n}"
  end

  factory :answer do
    body 
    question
  end

  factory :invalid_answer, class: "Answer" do
    title nil
    body nil
  end
end
