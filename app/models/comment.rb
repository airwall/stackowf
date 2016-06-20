class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :user, optional: true

  validates :user_id, :commentable_id, :commentable_type, :body, presence: true

  after_commit { CommentJob.perform_later(self) }
end
