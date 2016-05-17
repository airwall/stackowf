class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:edit, :destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @question }
        format.js
        flash[:notice] = "Answer was successfully added."
      else
        format.html { redirect_to @question }
        format.js { render nothing: true }
        flash[:alert] = "Answer can't be blank."
      end
    end
  end

  def edit
  end

  def destroy
    respond_to do |format|
      if current_user.author_of?(@answer)
        @answer.destroy!
        format.html { redirect_to question_path(@answer.question) }
        format.js
        flash[:alert] = "Answer was successfully destroyed."
      else
        format.html { redirect_to question_path(@answer.question) }
        format.js { render nothing: true }
        flash[:alert] = "You cannot delete this answer."
      end
      # redirect_to question_path(@answer.question)
    end
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
