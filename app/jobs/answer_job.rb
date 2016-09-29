class AnswerJob < ApplicationJob
  queue_as :default

  def perform(answer, attrs)
    ActionCable.server.broadcast "questions:#{answer.question_id}:answers",
                                 answer: attrs
  end
end
