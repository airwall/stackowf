$(document).ready ->
  $(document).on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    commentable_id = $(this).data('commentableId')
    commentable_type = $(this).data('commentableType')
    $("#form-comment-" + commentable_type + '-' + commentable_id).fadeIn(400)
    $('html, body').animate { scrollTop: $("#" + commentable_type + '_' + commentable_id + '_comments').offset().top - 100 }, 800

  $(document).on 'click', '.cancel-comment-form', (e) ->
    e.preventDefault();
    commentable_id = $(this).data('commentableId')
    commentable_type = $(this).data('commentableType')
    $("#form-comment-" + commentable_type + '-' + commentable_id).fadeOut(400)
    $("#form-comment-" + commentable_type + '-' + commentable_id + ' textarea').val('')
