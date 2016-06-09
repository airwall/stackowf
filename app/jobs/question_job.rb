class QuestionJob < ApplicationJob
  queue_as :default

  def perform(question)
    ActionCable.server.broadcast "questions",
      question: QuestionsController.render(partial: 'questions/question_index', locals: { question: question })
  end
end
