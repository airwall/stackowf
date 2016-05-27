require "features_helper"

feature "Remove files from question", "
  In order to illustrate my question
  As an a question author
  I'd like to be able to remove files from question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  before do
    create(:question_attachment, attachable: question)
    sign_in(user)
    visit question_path(question)
  end

  scenario "delete file", js: true do
    expect(page).to have_content "File 1"
    click_on "Edit Question"
    within (".edit_question_form") do
      click_on "Remove File"
      click_on "Submit"
    end
    expect(page).not_to have_content "File 1"
  end
end
