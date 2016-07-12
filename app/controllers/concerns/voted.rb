module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)
    render_voting
  end

  def vote_down
    @votable.vote_down(current_user)
    render_voting
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def render_voting
    render json: { id: @votable.id, score: @votable.vote_score, voted: @votable.status, resource: @votable.resource }
  end

  def set_votable
    @votable = model_klass.find(params[:id])
    authorize @votable, :vote?
  end
end
