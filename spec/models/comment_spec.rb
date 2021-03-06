require "rails_helper"

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it_behaves_like "perform job after commit" do
    let(:job) { CommentJob }
    let(:subject) { build(:answer_comment) }
  end
end
