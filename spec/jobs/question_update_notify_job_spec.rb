require 'rails_helper'

RSpec.describe QuestionUpdateNotifyJob, type: :job do
  let(:user) { create(:user) }
  let!(:record) { create(:question) }
  let!(:subscription) { create(:subscription, question: record, user: user) }
  let(:mailer_double) { double(QuestionMailer) }

  it 'schedule emails for subscribed users on question', :users do
    expect(QuestionMailer).to receive(:update).and_return(mailer_double)
    expect(mailer_double).to receive(:deliver_later)
    described_class.perform_now(record)
  end

  it_behaves_like "job perform"
end
