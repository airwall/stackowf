require "rails_helper"

describe Votable do
  with_model :WithVotable do
    table do |t|
      t.references :user
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  let(:user) { create(:user) }
  let(:votable) { WithVotable.create!(user: user) }

  describe "votes up" do
    it "votes up" do
      expect do
        votable.vote_up(user)
      end.to change(votable.votes, :count).by(1)
      expect(votable.vote_score).to eq 1
    end

    it "cancels vote" do
      votable.vote_up(user)
      expect do
        votable.vote_up(user)
      end.to change(votable.votes, :count).by(-1)
      expect(votable.vote_score).to eq 0
    end
  end

  describe "votes down" do
    it "votes up" do
      expect do
        votable.vote_down(user)
      end.to change(votable.votes, :count).by(1)
      expect(votable.vote_score).to eq -1
    end

    it "cancels vote" do
      votable.vote_down(user)
      expect do
        votable.vote_down(user)
      end.to change(votable.votes, :count).by(-1)
      expect(votable.vote_score).to eq 0
    end
  end
end
