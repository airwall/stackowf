class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.includes(:user).all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = current_user.questions.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = "Question was successfully created."
      redirect_to @question
    else
      flash[:alert] = "Question can't be blak."
      render :new
    end
  end

  def update
    if @question.update_attributes(question_params)
      flash[:notice] = "Question was successfully updated."
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:alert] = "Question was successfully destroyed."
      redirect_to questions_url
    else
      flash[:alert] = "You cannot delete this question."
      redirect_to @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
