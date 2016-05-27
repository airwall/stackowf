class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:edit, :destroy, :update, :best]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def best
    question = @answer.question
    if current_user.author_of?(@answer.question)
      @answer.best!
      @answers = question.answers.includes(:user).order("best DESC, created_at ASC")
      render :best
    else
      render :best
    end
  end

  def destroy
    @answer.destroy! if current_user.author_of?(@answer)
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
