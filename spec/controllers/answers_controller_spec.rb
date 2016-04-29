require "rails_helper"

RSpec.describe AnswersController do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:answer_attr) { attributes_for(:answer) }
    before { post :create, params: { answer: answer_attr, question_id: question.id } }
    context "With valide attributes" do
      it "creates a new answer" do
        expect do
          post :create, params: { answer: answer_attr, question_id: question.id }
        end.to change(question.answers, :count).by(1)
      end

      it "redirect to question view" do
        expect(response).to redirect_to question
      end
    end

    context "With invalid attributes" do
      it "does not save the answer" do
        expect do
          post :create, params: { answer: { body: nil }, question_id: question.id }
        end.to_not change(Answer, :count)
      end
      it "redirect to question view" do
        post :create, params: { answer: { body: nil }, question_id: question.id }
        expect(response).to redirect_to question
      end
    end
  end
end
