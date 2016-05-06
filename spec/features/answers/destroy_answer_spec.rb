require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user try destroy question' do
    sign_in(user)
    visit question_path(question)
    question.answers do |answer|
      click_on 'Delete Question'
      expect(page).to have_content 'Answer was successfully destroyed.'
    end
  end

  scenario 'Non-authenticated user ties to destroy question' do
    visit question_path(question)
    question.answers do |answer|
      expect(page).to_not have_content 'Delete Question'
    end
  end

end
