# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(document).on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    question_id = $(this).data('questionId');
    $('#edit-question-' + question_id).fadeIn('slow');
  $(document).on 'click', '.cancel-question-form', (e) ->
    e.preventDefault();
    question_id = $(this).data('questionId')
    $("#edit-question-" + question_id ).fadeOut(400)
