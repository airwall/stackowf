require "features_helper"

feature "Destroy Answer", '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask answer
' do
  given(:non_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }

  scenario "Authenticated user can deletes his answer", js: true do
    sign_in(user)
    answer.reload
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on "Delete"
      expect(page).to_not have_content "Answer was successfully destroyed."
    end
  end

  scenario "Authenticated user ties deletes not his answer", js: true do
    sign_in(non_author)
    answer.reload
    visit question_path(answer.question_id)

    expect(page).to_not have_link "Delete"
  end

  scenario "Non-authenticated user ties deletes answer", js: true do
    answer.reload
    visit question_path(answer.question_id)

    expect(page).to_not have_link "Delete"
  end
end
