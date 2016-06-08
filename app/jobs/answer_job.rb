class AnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    ActionCable.server.broadcast "questions:#{answer.question_id}:answers",
     answer: answer
  end
end
