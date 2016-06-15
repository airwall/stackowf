App.comments = App.cable.subscriptions.create "CommentsChannel",
  collection: -> $("[data-question-id]")

  connected: ->
    # Called when the subscription is ready for use on the server
    setTimeout =>
      @followCurrentAnswer()
      @installPageChangeCallback()
    , 1000

  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if gon.user_id != data.user_id
      comments = $('#' + data.commentable + '_' + data.commentable_id + '_comments')
      comments.append(data.comment).hide().fadeIn('slow')

  followCurrentAnswer: ->
    if questionId = @collection().data('question-id')
      @perform 'follow', commentable_id: questionId
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'page:change', -> App.answers.followCurrentPage()
