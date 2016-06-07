class AnswerJob < ApplicationJob
  def perform(answer)
    ActionCable.server.broadcast "questions:#{answer.question_id}:answers",
     answer: AnswersController.render(partial: 'answers/answer', locals: { answer: answer })
  end
end
