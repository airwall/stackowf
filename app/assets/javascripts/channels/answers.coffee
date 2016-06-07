App.answers = App.cable.subscriptions.create "AnswersChannel",
  collection: -> $("[data-channel='answers']")

  connected: ->
    # Called when the subscription is ready for use on the server
    setTimeout =>
      @followCurrentAnswer()
      @installPageChangeCallback()
    , 1000

  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    console.log data
    # Called when there's incoming data on the websocket for this channel
    $('#answers').append(data.answer)

  followCurrentAnswer: ->
    if questionId = @collection().data('question-id')
      @perform 'follow', question_id: questionId
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'page:change', -> App.answers.followCurrentPage()
