class Answer < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :user, optional: true
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :question_id, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  def best!
    transaction do
      question.answers.where(question_id: question_id).update_all(best: false)
      update!(best: true)
    end
  end
end
