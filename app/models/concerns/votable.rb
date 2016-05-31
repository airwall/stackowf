module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote = votes.find_or_create_by(user: user)
    vote.score != 1 ?  vote.update(score: 1) : votes.where(user: user).destroy_all
  end

  def vote_down(user)
    vote = votes.find_or_create_by(user: user)
    vote.score != -1 ?  vote.update(score: -1) : votes.where(user: user).destroy_all
  end

  def vote_score
    votes.sum(:score)
  end
end
