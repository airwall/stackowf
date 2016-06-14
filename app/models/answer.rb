class Answer < ApplicationRecord
  include Votable

  belongs_to :question, optional: true
  belongs_to :user, optional: true
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :question_id, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def best!
    transaction do
      question.answers.where(question_id: question_id).update_all(best: false)
      update!(best: true)
    end
  end

  def set_attr_for_template
    attr = serializable_hash.merge("username" => user.username, "author_question" => question.user_id).except("created_at", "updated_at")
    attr
  end

  after_create_commit { AnswerJob.perform_later(self, set_attr_for_template) }
end
