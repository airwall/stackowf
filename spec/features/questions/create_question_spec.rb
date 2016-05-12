require "rails_helper"

feature "Create question", '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
' do
  given(:user) { create(:user) }

  scenario "Authenticated user can create question" do
    sign_in(user)
    visit questions_path
    click_on "New Question"
    fill_in "Title", with: "Title"
    fill_in "Body", with: "NewQuestion123"
    click_on "Submit"

    expect(page).to have_content "Question was successfully created."
    expect(page).to have_content "NewQuestion123"
  end

  scenario "Non-authenticated user ties to create question" do
    visit questions_path
    click_on "New Question"
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
