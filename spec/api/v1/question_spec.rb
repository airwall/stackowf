require "rails_helper"

describe "Questions API" do
  let(:me) { create(:user, admin: true) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe "GET /index" do
    it_behaves_like "API Authenticable"

    context "authorized" do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get "/api/v1/questions", params: { access_token: access_token.token, format: :json } }

      it "returns 200 status code" do
        expect(response).to be_success
      end

      it "return list of questions" do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context "answers" do
        it "answer included in question" do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe "GET /show" do
    context "unauthorized" do
      it "return 401 if there not have access_token" do
        get "/api/v1/questions", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "return 401 if access_token invalid" do
        get "/api/v1/questions", params: { access_token: "1234", format: :json }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:question) { create(:question) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, format: :json } }

      it "returns 200 status code" do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context "comments" do
        it "comment included in question" do
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
    context "with valid params" do
      let(:post_question) do
        post "/api/v1/questions", params: {
          access_token: access_token.token, format: :json, question: attributes_for(:question)
        }
      end

      it "returns 201 status" do
        post_question
        expect(response.status).to eq 201
      end

      it "creates question" do
        expect { post_question }.to change(Question, :count).by(1)
      end
    end

    context "with invalid params" do
      let(:post_invalid_question) do
        post "/api/v1/questions", params: {
          access_token: access_token.token, format: :json, question: attributes_for(:invalid_question)
        }
      end

      it "returns 422 status" do
        post_invalid_question
        expect(response.status).to eq 422
      end

      it "does not creates answer" do
        expect { post_invalid_question }.not_to change(Question, :count)
      end
    end
  end

  def do_request(options = {})
    get "/api/v1/questions", params: { format: :json }.merge(options)
  end
end
