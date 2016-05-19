require 'features_helper'

feature "Destroy Answer", '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario "Authenticated user can deletes his answer" do
    sign_in(user)

    create(:answer, user: user, question: question)

    visit question_path(question)
    click_on "Delete Answer"

    expect(page).to have_content "Answer was successfully destroyed."
  end

  scenario "Authenticated user ties deletes not his answer" do
    sign_in(user)
    visit question_path(answer.question_id)

    expect(page).to_not have_link "Delete Answer"
  end

  scenario "Non-authenticated user ties deletes answer" do
    visit question_path(answer.question_id)

    expect(page).to_not have_link "Delete Answer"
  end
end
