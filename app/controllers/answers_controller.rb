class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question, notice: "Answer was successfully added."
    else
      redirect_to @question, notice: "Fill all inputs of answer"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
