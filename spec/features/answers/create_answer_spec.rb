require "rails_helper"

feature "Create answer", '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

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

    expect(current_path).to eq question_path(question)
  end

  scenario "Non-authenticated user ties  to create answer" do
    visit question_path(question)
    expect(page).to_not have_content "Submit"
  end
end
