require "rails_helper"

RSpec.describe AnswersController do
  sign_in_user
  let(:question) { create(:question) }
  let(:answer) { question.answers.first }

  describe 'POST #create' do
    let(:answer_attr) { attributes_for(:answer) }
    before { post :create, params: { answer: answer_attr, question_id: question.id } }

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
        expect(response).to render_template :create
      end
    end

    context "with invalid attributes via AJAX" do
      let(:invalid_ajax_answer) {  post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }, format: :js }

      it "Save answer for question in database" do
        expect { invalid_ajax_answer }.to_not change(Answer, :count)
      end

      it "render @question_path" do
        invalid_ajax_answer
        expect(response).to render_template :create
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
        expect(response).to render_template :destroy
      end
    end

    context "Non-author" do
      it "non-author deletes answer" do
        new_answer = create(:answer, question: question, user: create(:user))
        expect { delete :destroy, params: { id: new_answer, question_id: question }, format: :js }.to_not change(Answer, :count)
        expect(response).to render_template :destroy
      end

      it "redirect to question view" do
        new_answer = create(:answer, question: question, user: create(:user))
        delete :destroy, params: { id: new_answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: @user) }
    let(:valid_update) { patch :update, params: { id: answer, answer: { body: "12345678910" } }, format: :js }

    context "by not the author of answer" do
      before { valid_update }

      it "does not change answer attributes" do
        expect(answer.body).to_not eq "12345678910"
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end

    context "with valid attributes by author" do
      let(:answer) { create(:answer, user_id: @user.id) }
      before { valid_update }

      it "assign requested answer to @answer" do
        expect(assigns(:answer)).to eq answer
      end

      it "change answer attributes" do
        answer.reload
        expect(answer.body).to eq "12345678910"
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end

    context "with invalid attributes by author" do
      let(:answer) { create(:answer, user_id: @user.id) }
      before { patch :update, params: { id: answer, answer: { body: nil } }, format: :js }

      it "does not change answer attributes" do
        answer.reload
        expect(answer.body).to_not eq nil
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #BEST set best answer' do
    let(:answer) { create(:answer, question: question) }
    let(:valid_update) { patch :best, params: { id: answer }, format: :js }

    context "by the author of question" do
      let(:question) { create(:question, user: @user) }
      before { valid_update }

      it "assigns answer to answer" do
        answer.reload
        expect(assigns(:answer)).to eq answer
      end

      it "accepts the answer" do
        answer.reload
        expect(answer.best).to eq true
      end

      it "redirect to question view" do
        expect(response).to render_template :best
      end
    end

    context "by not the author of the question" do
      let(:answer) { create(:answer, question: question) }
      before { valid_update }

      it "doesnt change best_answer attribute of question" do
        answer.reload
        expect(answer.best?).to eq false
      end

      it "redirect to question view" do
        expect(response).to render_template :best
      end
    end
  end
end
