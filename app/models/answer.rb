class Answer < ApplicationRecord
  belongs_to :question, optional: true

  validates :question_id, :body, presence: true
end
