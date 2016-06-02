$(document).ready ->
  $(document).on 'ajax:success', '.vote', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    resource = response.resource + '_' + response.id

    if response.voted == "up"
      $('#votable_' + resource + ' #up').css('color', '#888')
      $('#votable_' + resource + ' #down').css('color', '#e0e0e0')
      $('#votable_' + resource + ' .score').text(response.score).hide().fadeIn('slow')
    else if response.voted == "down"
      $('#votable_' + resource + ' #down').css('color', '#888')
      $('#votable_' + resource + ' #up').css('color', '#e0e0e0')
      $('#votable_' + resource + ' .score').text(response.score).hide().fadeIn('slow')
    else if response.voted == "none"
      $('#votable_' + resource + ' #up').css('color', '#888')
      $('#votable_' + resource + ' #down').css('color', '#888')
      $('#votable_' + resource + ' .score').text(response.score).hide().fadeIn('slow')
