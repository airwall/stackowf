every 1.day do
  runner "QuestionDigestJob.perform_later"
end

every 60.minutes do
  rake "ts:index"
end
