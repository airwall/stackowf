App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    setTimeout =>
      @followCurrentPage()
      @installPageChangeCallback()
    , 1000

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('.questions').before().append(data.question).hide().fadeIn('slow')

  followCurrentPage: ->
    if $('[data-questions-channel]')
      @perform 'follow'
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'page:change', -> App.comments.followCurrentMessage()
