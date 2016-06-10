require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:valid_question_comment) do
    post :create, xhr: true, params: { comment: attributes_for(:comment),
                                       question_id: question,
                                       commentable: question }
  end
  let(:invalid_question_comment) do
    post :create, xhr: true, params: { comment: attributes_for(:invalid_comment),
                                       question_id: question,
                                       commentable: question }
  end

  let(:valid_answer_comment) do
    post :create, xhr: true, params: { comment: attributes_for(:comment),
                                       answer_id: answer,
                                       commentable: answer }
  end
  let(:invalid_answer_comment) do
    post :create, xhr: true, params: { comment: attributes_for(:invalid_comment),
                                       answer_id: answer,
                                       commentable: answer }
  end

  describe 'POST #create' do
    # ==== for Question ====================================== //
    context "Authenticated user can comment Question" do
      before { sign_in user }
      it "Save comment in the database and asign to question" do
        expect { valid_question_comment }.to change(question.comments, :count).by(1)
      end

      it "Save comment in the database and asign to user" do
        valid_question_comment
        expect(question.comments.first.user_id).to eq user.id
      end
    end

    context "Authenticated user comment Question with invalid attributes" do
      before { sign_in user }
      it "Don't save comment in the database" do
        expect { invalid_question_comment }.to_not change(question.comments, :count)
      end
    end

    context "Guest can't create comment to question" do
      it "return unauthorized" do
        valid_question_comment
        expect(response).to have_http_status :unauthorized
      end

      it "don't save comment in database " do
        expect { invalid_question_comment }.to_not change(question.comments, :count)
      end
    end

    #======== for Answer ====================================== //
    context "Authenticated user can comment Answer" do
      before { sign_in user }
      it "Save comment in the database and asign to answer" do
        expect { valid_answer_comment }.to change(answer.comments, :count).by(1)
      end

      it "Save comment in the database and asign to user" do
        valid_answer_comment
        expect(answer.comments.first.user_id).to eq user.id
      end
    end

    context "Authenticated user comment Answer with invalid attributes" do
      before { sign_in user }
      it "Don't save comment in the database" do
        expect { invalid_answer_comment }.to_not change(answer.comments, :count)
      end
    end

    context "Guest can't create comment to answer" do
      it "return unauthorized" do
        valid_answer_comment
        expect(response).to have_http_status :unauthorized
      end

      it "don't save comment in database " do
        expect { invalid_answer_comment }.to_not change(answer.comments, :count)
      end
    end
  end
end
