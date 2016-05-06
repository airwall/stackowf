class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:edit]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      flash[:notice] = "Answer was successfully added."
      redirect_to question_path(@question)
    else
      flash[:notice] = "Answer can't be blank."
      redirect_to question_path(@question)
    end
  end

  def edit
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
