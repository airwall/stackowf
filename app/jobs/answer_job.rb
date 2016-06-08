class AnswerJob < ApplicationJob
  def perform(answer)
    # binding.pry
    ActionCable.server.broadcast "questions:#{answer.question_id}:answers",
     answer: AnswersController.render(partial: 'answers/answer', locals: { answer: answer })
  end
end
