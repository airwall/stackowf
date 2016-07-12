class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show

  respond_to :html, :js

  include Voted

  def index
    respond_with(@questions = Question.includes(:user).all)
  end

  def show
    respond_with @question
  end

  def new
    authorize Question
    respond_with(@question = current_user.questions.new)
  end

  def create
    authorize Question
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    @question.destroy 
    respond_with @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
    authorize @question
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
