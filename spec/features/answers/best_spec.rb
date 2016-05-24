require "features_helper"

feature "User can make best answer", '
  In order to change inaccurate answer
  As an authenticated user and author of question
  I want to make best answer
' do
  given(:non_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: non_author, question: question) }
  given(:answer2) { create(:answer, user: non_author, question: question) }

  scenario "authenticated user make best answer on his question", js: true do
    sign_in(user)
    answer.reload
    visit question_path(question)
    within "#answer_#{answer.id}" do
      expect(page).to have_link "Best"
      expect(page).to_not have_css ".glyphicon.glyphicon-ok.green"
      click_on "Best"
      expect(page).to have_css ".glyphicon.glyphicon-ok.green"
    end
  end

  scenario "authenticated user make best answer on not his question", js: true do
    sign_in(non_author)
    answer.reload
    visit question_path(question)
    within "#answer_#{answer.id}" do
      expect(page).to_not have_link "Best"
      expect(page).to_not have_css ".glyphicon.glyphicon-ok.green"
    end
  end

  scenario "non-authenticated user make best answer", js: true do
    answer.reload
    visit question_path(question)
    within "#answer_#{answer.id}" do
      expect(page).to_not have_link "Best"
      expect(page).to_not have_css ".glyphicon.glyphicon-ok.green"
    end
  end
end
