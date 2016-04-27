class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @question, notice: "Answer was successfully added." }
      else
        format.html { redirect_to @question, notice: "Fill all inputs of answer" }
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :qustion_id)
  end
end
