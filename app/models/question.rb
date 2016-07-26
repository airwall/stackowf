class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user, optional: true

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_commit { QuestionJob.perform_later(self) }
  after_create_commit :subscribe_user
  after_update :notify_users, if: "body_changed?"

  private

  def subscribe_user
    subscriptions.create(user_id: user_id)
  end

  def notify_users
    QuestionUpdateNotifyJob.perform_later(self)
  end
end
