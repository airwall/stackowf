module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote = votes.find_or_initialize_by(user: user)
    vote.score != 1 ? vote.update!(score: 1) && @status = "up" : (vote.destroy! && @status = "none" if voted_by?(user))
  end

  def vote_down(user)
    vote = votes.find_or_initialize_by(user: user)
    vote.score != -1 ? vote.update!(score: -1) && @status = "down" : (vote.destroy! && @status = "none" if voted_by?(user))
  end

  def vote_score
    votes.sum(:score)
  end

  def status
    @status
  end

  def resource
    model_name.singular
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end
end
