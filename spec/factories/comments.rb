FactoryGirl.define do
  factory :comment do
    user
    sequence(:body) { |n| "Comment #{n}" }
    factory :question_comment do
      association :commentable, factory: :question
    end
    factory :answer_comment do
      association :commentable, factory: :answer
    end

    factory :invalid_comment, class: "Comment" do
      user
      body nil
    end
  end
end
