require "rails_helper"

shared_examples "renders the headers" do |subject|
  it "renders the headers" do
    expect(mail.subject).to eq(subject)
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(["test@test.com"])
  end
end

RSpec.describe QuestionMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question, 2) }
  let(:question) { questions.first }

  describe "digest", :users do
    let(:mail) { described_class.digest(user, questions) }

    it_behaves_like "renders the headers", "Digest"

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello! Here is the digest of new questions for last 24 hours!")
      expect(mail.body.encoded).to match(questions.first.title)
      expect(mail.body.encoded).to match(questions.second.title)
      expect(mail.body.encoded).to match(url_for(questions.first))
      expect(mail.body.encoded).to match(url_for(questions.second))
    end
  end
end
