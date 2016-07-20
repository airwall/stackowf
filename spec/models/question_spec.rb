require "rails_helper"

RSpec.describe Question do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it_behaves_like 'perform job after commit' do
    let(:job) { QuestionJob }
    let(:subject) { build(:question) }
  end
end
