class QuestionJob < ApplicationJob
  queue_as :low_priority

  def perform(question)
    ActionCable.server.broadcast "questions",
                                 question: QuestionsController.render(partial: "questions/question_index", locals: { question: question })
  end
end
