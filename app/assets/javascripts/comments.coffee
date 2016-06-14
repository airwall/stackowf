$(document).ready ->
  $(document).on 'click', '.add-comment-link', (e) ->
    e.preventDefault();

    commentable_id = $(this).data('commentableId')
    $("#form-comment-" + commentable_id).fadeIn(1000)
    $('.add-comment-link').hide()

  $(document).on 'ajax:success', '.comment-form', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $(".comment-errors").text('')
    $("#form-comment-#{response.commentable_id} textarea" ).val('')
    $("#form-comment-" + response.commentable_id).fadeOut(400)
    $('.add-comment-link').show()
