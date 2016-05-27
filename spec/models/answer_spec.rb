require "rails_helper"

RSpec.describe Answer do
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

  describe "#best method" do
    it "method change answer.best from false to true" do
      answer = create(:answer, best: false)
      expect do
        answer.best!
      end.to change { answer.best }.from(false).to(true)
    end

    it "method change new answer.best from true to false" do
      question = create(:question)
      answer1 = create(:answer, question: question, best: true)
      answer2 = create(:answer, question: question, best: false)

      expect { answer2.best! }.to change { answer1.reload.best }.from(true).to(false)
      expect(answer2.best?).to eq true
    end
  end
end
