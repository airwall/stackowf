require "rails_helper"

describe "Answers API" do
  let(:me) { create(:user, admin: true) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:question) { create(:question) }

  describe "GET /index" do
    it_behaves_like "API Authenticable"

    context "authorized" do
      let!(:answers) { create_pair(:answer, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, format: :json } }

      it "returns 200 status code" do
        expect(response).to be_success
      end

      it "return list of answers" do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe "GET /show" do
    let!(:answer) { create(:answer, question: question) }

    context "unauthorized" do
      it "return 401 if there not have access_token" do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "return 401 if access_token invalid" do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { access_token: "1234", format: :json }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { access_token: access_token.token, format: :json } }

      it "returns 200 status code" do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context "comments" do
        it "comment included in answer" do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context "attachments" do
        it "includes attachments" do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end
  end

  describe 'POST #create' do
    let!(:question) { create(:question) }

    context "with valid params" do
      let(:post_answer) do
        post "/api/v1/questions/#{question.id}/answers", params: {
          access_token: access_token.token, format: :json, answer: attributes_for(:answer), question_id: question
        }
      end

      it "returns 201 status" do
        post_answer
        expect(response.status).to eq 201
      end

      it "creates answer" do
        expect { post_answer }.to change(question.answers, :count).by(1)
      end
    end

    context "with invalid params" do
      let(:post_invalid_answer) do
        post "/api/v1/questions/#{question.id}/answers", params: {
          access_token: access_token.token, format: :json, answer: attributes_for(:invalid_answer), question_id: question
        }
      end

      it "returns 422 status" do
        post_invalid_answer
        expect(response.status).to eq 422
      end

      it "does not creates answer" do
        expect { post_invalid_answer }.not_to change(question.answers, :count)
      end
    end
  end

  def do_request(options = {})
    get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
  end

end
