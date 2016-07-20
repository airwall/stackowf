$(document).ready ->
  $(document).on 'ajax:success', '.subscription', (e, data, status, xhr) ->
    e.preventDefault();
    console.log (status)
    if status == 'nocontent'
      $('#subscribed').addClass('hide')
      $('#unsubscribed').removeClass('hide')
    else
      $('#unsubscribed').addClass('hide')
      $('#subscribed').removeClass('hide')
