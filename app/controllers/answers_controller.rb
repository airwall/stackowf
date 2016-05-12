class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:edit, :destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
      flash[:notice] = "Answer was successfully added."
    else
      flash[:alert] = "Answer can't be blank."
    end
    redirect_to question_path(@question)
  end

  def edit
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy!
      flash[:notice] = "Answer was successfully destroyed."
    else
      flash[:alert] = "You cannot delete this answer."
    end
    redirect_to question_path(@answer.question)
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
