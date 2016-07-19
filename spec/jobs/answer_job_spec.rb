require "rails_helper"

shared_context "shared job", type: :job do
  around do |example|
    active_job_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    example.run
    ActiveJob::Base.queue_adapter = active_job_queue_adapter
  end

  let(:hash) { {} }
end

shared_examples "enqueue job answer" do
  it "matches params with enqueued job" do
    expect do
      described_class.perform_later(record)
    end.to have_enqueued_job.with(record)
  end

  it "broadcasts to ActionCable" do
    expect(ActionCable.server).to receive(:broadcast).with(channel, hash_including(hash))
    described_class.perform_now(record, attachment)
  end
end

RSpec.describe AnswerJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:record) { create(:answer, question: question) }
  let(:attachment) { { username: user.username, author_question: question.user_id } }
  let(:channel) { "questions:#{record.question_id}:answers" }

  it_behaves_like "enqueue job answer"
end
