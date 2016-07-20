require "rails_helper"

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456") }

    context "User already has authorization" do
      it "returns the authorization" do
        user.authorizations.create(provider: "facebook", uid: "123456")
        expect(User.find_for_oauth(auth)).to be_a(Authorization)
      end
    end

    context "User don't have authorization" do
      context "user already exist" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: user.email }) }
        it "doest not create new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "create authorization for user" do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "create authorization with provider and uid" do
          User.find_for_oauth(auth)
          expect(user.authorizations.first.provider).to eq auth.provider
          expect(user.authorizations.first.uid).to eq auth.uid
        end

        it "return authorization" do
          expect(User.find_for_oauth(auth)).to be_a(Authorization)
        end
      end

      context "User does not exist" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: "new@user.com" }) }

        it "create new user with email" do
          user = User.find_for_oauth(auth).user
          expect(user.email).to eq "new@user.com"
        end

        it "creates new Authorization for new user" do
          user = User.find_for_oauth(auth).user
          expect(user.authorizations).to_not be_empty
        end

        it "create new Authorization with provider and uid" do
          user = User.find_for_oauth(auth).user
          expect(user.authorizations.first.provider).to eq auth.provider
          expect(user.authorizations.first.uid).to eq auth.uid
        end

        it "returns new authorization" do
          expect(User.find_for_oauth(auth)).to be_a(Authorization)
        end
      end
    end
  end
end
