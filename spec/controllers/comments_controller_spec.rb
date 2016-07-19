require "rails_helper"
shared_examples "comments" do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:post_comment) { post :create, xhr: true, params: { comment: attributes_for(:comment) }.merge(shared_object) }
    let(:post_invalid_comment) { post :create, xhr: true, params: { comment: attributes_for(:invalid_comment) }.merge(shared_object) }

    context "Authenticated user can add comment" do
      before { sign_in user }
      it "Save comment in the database and asign to question" do
        expect { post_comment }.to change(commentable.comments, :count).by(1)
      end

      it "Save comment in the database and asign to user" do
        post_comment
        expect(commentable.comments.first.user_id).to eq user.id
      end
    end

    context "Authenticated user can't comment with invalid attributes" do
      before { sign_in user }
      it "Don't save comment in the database" do
        expect { post_invalid_comment }.to_not change(commentable.comments, :count)
      end
    end

    context "Guest can't create comment" do
      it "return unauthorized" do
        post_comment
        expect(response).to have_http_status :unauthorized
      end

      it "don't save comment in database " do
        expect { post_invalid_comment }.to_not change(commentable.comments, :count)
      end
    end
  end
end

RSpec.describe CommentsController, type: :controller do
  let!(:question) { create(:question) }

  context "question" do
    it_behaves_like "comments" do
      let(:commentable) { question }
      let(:shared_object) { { question_id: question, commentable: "questions" } }
    end
  end

  context "answer" do
    it_behaves_like "comments" do
      let(:commentable) { create(:answer, question: question) }
      let(:shared_object) { { question_id: question, answer_id: commentable, commentable: "answers" } }
    end
  end
end
