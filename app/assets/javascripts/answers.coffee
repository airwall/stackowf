# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId');
    $('#edit-answer-' + answer_id).fadeIn(1000);
  $(document).on 'click', '.cancel-answer-form', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $("#edit-answer-" + answer_id ).fadeOut(400)
