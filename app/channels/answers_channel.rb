# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions:#{data['question_id'].to_i}:answers"
  end

  def unfollow
    stop_all_streams
  end
end
