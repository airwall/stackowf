class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true, touch: true
  belongs_to :user, optional: true

  validates :user_id, :commentable_id, :commentable_type, :body, presence: true

  default_scope -> { order(:created_at => :asc) }

  after_commit { CommentJob.perform_later(self) }
end
