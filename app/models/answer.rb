class Answer < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :user, optional: true

  validates :question_id, :body, :user_id, presence: true
end
