require "features_helper"

feature "User can edit his answer", '
  In order to change inaccurate answer
  As an authenticated user
  I want to edit my answer
' do
  given(:non_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }

  scenario "authenticated user edit his answer", js: true do
    sign_in(user)
    answer.reload
    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on "Edit Answer"
      fill_in "Body", with: "Edited answer"
      click_on "Submit"
      expect(page).to have_content "Edit Answer"
    end
  end

  scenario "authenticated user edit another's answer", js: true do
    sign_in(non_author)
    answer.reload
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to_not have_link "Edit Answer"
    end
  end

  scenario "non-authenticated user edit answer", js: true do
    answer.reload
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to have_content answer.body
      expect(page).to_not have_link "Edit Answer"
    end
  end
end
