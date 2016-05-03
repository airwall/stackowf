require "rails_helper"

RSpec.describe AnswersController do
  let(:question) { create(:question) }

  describe 'GET #edit' do
    let(:answer) { create(:answer) }
    before { get :edit, params: { id: answer } }

    it "assigns the requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end

    it "render edit view" do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
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
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end
      it "redirect to question view" do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id }
        expect(response).to redirect_to question
      end
    end
  end
end
