require "rails_helper"

RSpec.describe CommentJob, type: :job do
  let(:channel) { "questions:#{record.commentable_id}:comments" }
  let(:hash) { {commentable: record.commentable_type.underscore, commentable_id: record.commentable_id} }

  context 'question' do
    let(:record) { create(:question_comment) }

    it_behaves_like 'enqueue job'
  end

  context 'answer' do
    let(:channel) { "questions:#{record.commentable.question_id}:comments" }
    let(:record) { create(:answer_comment) }

    it_behaves_like 'enqueue job'
  end
end
