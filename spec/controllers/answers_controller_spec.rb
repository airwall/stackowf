require "rails_helper"

RSpec.describe AnswersController do
  sign_in_user
  let(:question) { create(:question) }
  let(:answer) { question.answers.first }

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

      it "Answer assignes to author" do
        expect do
          post :create, params: { answer: answer_attr, question_id: question.id }
        end.to change(@user.answers, :count).by(1)
      end

      it "redirect to question view" do
        expect(response).to redirect_to question
      end
    end

    context "with valid attributes via AJAX" do
      let(:ajax_answer) { post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js }

      it "Save answer for question in database" do
        expect { ajax_answer }.to change(question.answers, :count).by(1)
      end

      it "Answer assignes to author" do
        expect { ajax_answer }.to change(@user.answers, :count).by(1)
      end

      it "redirect to question view" do
        ajax_answer
        expect(response).to redirect_to question
      end
    end

    context "with invalid attributes via AJAX" do
      let(:invalid_ajax_answer) {  post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }, format: :js }

      it "Save answer for question in database" do
        expect { invalid_ajax_answer }.to_not change(Answer, :count)
      end

      it "render @question_path" do
        invalid_ajax_answer
        expect(response.status).to eq(200)
      end
    end

    context "With invalid attributes" do
      it "does not save the answer" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end
      it "redirect to question view" do
        expect(response).to redirect_to question
      end
    end
  end

  describe 'DELETE #destroy' do
    context "Author" do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: @user) }

      it "User can delete answer via ajax" do
        expect { delete :destroy, params:  { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      it "redirect to question view" do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to redirect_to question
      end
    end

    context "Non-author" do
      it "non-author deletes answer" do
        new_answer = create(:answer, question: question, user: create(:user))
        expect { delete :destroy, params: { id: new_answer, question_id: question }, format: :js }.to_not change(Answer, :count)
        expect(response.status).to eq(200)
      end

      it "redirect to question view" do
        new_answer = create(:answer, question: question, user: create(:user))
        delete :destroy, params: { id: new_answer, question_id: question }, format: :js
        expect(response.status).to eq(200)
      end
    end
  end
end
