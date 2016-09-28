class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:edit, :destroy, :update, :best]
  before_action :get_answer_question, only: [:best, :update]

  respond_to :html, :js

  include Voted

  def create
    authorize Answer
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def best
    @answer.best!
    respond_with @answers = @question.answers.includes(:user).order("best DESC, created_at ASC")
  end

  def destroy
    respond_with @answer.destroy
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.find(params[:id])
    authorize @answer
  end

  def get_answer_question
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
