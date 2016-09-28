class AnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    ActionCable.server.broadcast "questions:#{answer.question_id}:answers",
                                 answer: AnswersContrller.render(partial: "answers/answer", locals: {answer: answer} )
  end
end
