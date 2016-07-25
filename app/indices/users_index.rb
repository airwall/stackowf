ThinkingSphinx::Index.define :user, with: :active_record do
  indexes email
  indexes username
end
