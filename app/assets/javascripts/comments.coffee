$(document).ready ->
  $(document).on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    commentable_id = $(this).data('commentableId')
    commentable_type = $(this).data('commentableType')
    console.log($("#form-comment-" + commentable_type + '-' + commentable_id))
    $("#form-comment-" + commentable_type + '-' + commentable_id).fadeIn(400)
  # $(document).on 'ajax:success', '.new_comment', (e, data, status, xhr) ->
  #   response = $.parseJSON(xhr.responseText)
  #   $(".comment-errors").text('')
  #   $("#form-comment-#{response.commentable_id} textarea" ).val('')
  #   $("#form-comment-" + response.commentable_id).fadeOut(400)
  #   $('.add-comment-link').after().show()
