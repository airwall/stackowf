require "rails_helper"
require "capybara/email/rspec"

RSpec.describe OauthServicesController, type: :controller do
  describe "get #new_email_oauth" do
    it "render new_email_oauth view" do
      get :new_email_oauth
      expect(response).to render_template :new_email_oauth
    end
  end

  describe "post #save_email_oauth" do
    context "with valid attributes" do
      let(:save_email_oauth) { post :save_email_oauth, { email: "test@test.com" }, uid: "12345", provider: "twitter" }

      it "redirect to sign in page" do
        save_email_oauth
        expect(response).to redirect_to confirm_web_path
      end

      it "sends an email" do
        expect { save_email_oauth }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "with invalid attributes" do
      it "render new_email_oauth view" do
        post :save_email_oauth, email: ""
        expect(response).to render_template :new_email_oauth
      end
    end
  end

  describe "get #confirm_email #confirm_web" do
    context "with valid attributes" do
      let!(:auth) { create(:authorization) }
      let!(:old_hash) { auth.confirmation_hash }
      before { get :confirm_email, token: auth.confirmation_hash }

      it "set authorization confirmed status true" do
        auth.reload
        expect(auth.confirmed).to eq true
      end

      it "change authorization confirmation hash" do
        auth.reload
        expect(auth.confirmation_hash).to_not eq old_hash
      end

      it "redirect to login with provider" do
        expect(response).to redirect_to "/users/auth/#{auth.provider}"
      end
    end

    context "with invalid attributes" do
      it "redirect to login with provider" do
        get :confirm_email, provider: nil, uid: nil, token: nil
        expect(response).to redirect_to new_user_session_path(redirect_to: root_path)
      end
    end
  end

  describe "get #confirm_web" do
    it "render confirm_web view" do
      get :confirm_web
      expect(response).to render_template :confirm_web
    end
  end
end
