require 'features_helper'

feature "User can see list question and answers" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario "Autenticated user can see answers" do
    sign_in(user)
    answer

    visit question_path(question)

    expect(page).to have_content answer.body
  end

  scenario "Non-autenticated user can see answers" do
    answer

    visit question_path(question)

    expect(page).to have_content answer.body
  end
end
