require "features_helper"

feature "Remove files from answer", "
  In order to illustrate my answer
  As an a answer author
  I'd like to be able to remove files from answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  before do
    create(:answer_attachment, attachable: answer)
    sign_in(user)
    visit question_path(question)
  end

  scenario "delete file", js: true do
    expect(page).to have_content "File 1"
    click_on "Edit Answer"
    within "#answer_#{answer.id}" do
      click_on "Remove File"
      click_on "Submit"
    end
    expect(page).not_to have_content "File 1"
  end
end
