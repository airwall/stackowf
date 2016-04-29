class AnswersController < ApplicationController
  before_action :get_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question, notice: "Answer was successfully added."
    else
      redirect_to @question
    end
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
