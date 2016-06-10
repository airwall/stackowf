FactoryGirl.define do
  factory :comment do
    user
    body "Comment"
  end

  factory :invalid_comment, class: "Comment" do
    user
    body nil
  end
end
