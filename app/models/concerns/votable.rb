module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote = votes.find_or_create_by(user: user)
    (vote.update(score: 1) && @status = true if vote.score != 1) || (votes.where(user: user).destroy_all && @status = false if voted_by?(user))
  end

  def vote_down(user)
    vote = votes.find_or_create_by(user: user)
    (vote.update(score: -1) && @status = true if vote.score != -1) || (votes.where(user: user).destroy_all && @status = false if voted_by?(user))
  end

  def vote_score
    votes.sum(:score)
  end

  def status
    @status
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end
end
