require "rails_helper"

describe "Profile API" do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe "GET /me" do
    it_behaves_like "API Authenticable"

    context "Authorized" do
      before { get "/api/v1/profiles/me", params: { access_token: access_token.token, format: :json } }

      it "return status 200" do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(encrypted_password password).each do |attr|
        it "Not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #all' do
    context "unauthorized" do
      it "return 401 if there not have access_token" do
        get "/api/v1/profiles/all", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "return 401 if access_token invalid" do
        get "/api/v1/profiles/all", params: { access_token: "1234", format: :json }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:user) { create(:user) }
      before { get "/api/v1/profiles/all", params: { access_token: access_token.token, format: :json } }

      it "returns 200 status" do
        expect(response).to be_success
      end

      it "includes user" do
        expect(response.body).to include_json(user.to_json)
      end

      it "does not includes signed in user" do
        expect(response.body).not_to include_json(me.to_json)
      end

      it "returns 1 user" do
        expect(response.body).to have_json_size(1)
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).not_to have_json_path("0/#{attr}")
        end
      end
    end
  end

  def do_request(options = {})
    get "/api/v1/profiles/me", params: { format: :json }.merge(options)
  end

end
