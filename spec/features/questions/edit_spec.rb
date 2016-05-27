require "features_helper"

feature "Edit question", '
  In order to get answer from community
  As an authenticated user
  I want to be able to edit question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "Authenticated user can edit question", js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.title

    within "#question_#{question.id}" do
      click_on "Edit Question"
      fill_in "Title", with: "NewTitle"
      fill_in "Body", with: "NewBody"
      click_on "Submit"
    end

    expect(page).to have_content "NewTitle"
  end

  scenario "Non-authenticated user ties to create question" do
    visit question_path(question)
    expect(page).to_not have_link "Edit Question"
  end
end
