require 'features_helper'

feature "Create answer", '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask answer
' do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario "Authenticated user can create answer", js: true do
    sign_in(user)
    visit question_path(question)
    fill_in "Body", with: "NewAnswer123"
    click_on "Submit"
    within '#answers' do
      expect(page).to have_content "NewAnswer123"
    end
  end

  scenario "Authenticated user ties create answer with invalid attributes", js: true do
    sign_in(user)
    visit question_path(question)
    fill_in "Body", with: nil
    click_on "Submit"

    within '.answers-errors' do
      expect(page).to have_content " Body can't be blank"
    end
  end

  scenario "Non-authenticated user ties  to create answer", js: true do
    visit question_path(question)
    expect(page).to_not have_content "Submit"
  end
end
