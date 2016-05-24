class Answer < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :user, optional: true

  validates :question_id, :body, :user_id, presence: true

  def best!
    transaction do
      question.answers.where(question_id: question_id).update_all(best: false)
      update!(best: true)
    end
  end
end
