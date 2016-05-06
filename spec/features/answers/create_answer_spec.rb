require 'rails_helper'

feature 'Create answer', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user can create answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer'
    click_on 'Submit'
    expect(page).to have_content 'Answer was successfully added.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user ties create answer with invalid attributes' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: nil
    click_on 'Submit'
    expect(page).to have_content "Answer can't be blank."
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user ties  to create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'Answer'
    click_on 'Submit'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
