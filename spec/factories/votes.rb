FactoryGirl.define do
  factory :vote do
    user
    score 1
    factory :fake_vote, class: "Fake" do
      association :votable, factory: :fake
    end
  end
end
