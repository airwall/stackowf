class CommentJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ActionCable.server.broadcast "questions:#{channel_id(comment)}:comments",
                                 comment: CommentsController.render(partial: 'comments/comment', locals: { comment: comment }),
                                 commentable: comment.commentable_type.underscore,
                                 commentable_id: comment.commentable_id
  end

  private

  def channel_id(comment)
    comment.commentable_type == 'Answer' ? comment.commentable.question_id : comment.commentable_id
  end
end
