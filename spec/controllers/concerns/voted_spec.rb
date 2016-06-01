require 'rails_helper'

class FakesController < ApplicationController
  include Voted
end

describe FakesController do
  with_model :fake do
    table do |t|
      t.references :user
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  before { routes.draw {
    post 'vote_up' => 'fakes#vote_up'
  } }

  sign_in_user
  let(:user) {create(:user) }
  let(:votable) { Fake.create!(user: @user) }
  let(:vote_up) { post :vote_up, params: { id: votable }, format: :js }

  context 'Vote up if user is not author of votable' do
    before { sign_in user }

    it "create vote with value 1" do
      vote_up
      expect(votable.votes.first.score).to eq 1
    end

    it "render json with votable id and rating" do
      vote_up
      expect(response.body).to eq ({ id: votable.id, score: votable.vote_score, voted: true }).to_json
    end
  end

  context 'Cancel vote up if user is not author of votable' do
    before { sign_in user }
    it 'cancel vote' do
      expect {
        post :vote_up, params: {id: @user, format: :json}
      }.not_to change(votable.votes, :count)
    end

    # let(:vote) { create(:vote, score: 1, votable: votable, user: @user) }
    # before { vote_up }
    # before { sign_in user }
    #
    # it "Cancel vote" do
    #   vote.reload
    #   vote_up
    #   binding.pry
    #   expect(votable.votes.last.score).to eq 0
    # end
  end

  context 'if user is author of votable' do

    it "doesn't create vote" do
      vote_up
      expect(votable.votes.count).to eq 0
    end

    it "render nothing with status 403" do
      vote_up
      expect(response.body).to eq ''
      expect(response.status).to eq 403
    end
  end
end
