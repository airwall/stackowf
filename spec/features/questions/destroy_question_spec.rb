require "rails_helper"

feature "Destroy Question", '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
' do
  given(:user) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "Authenticated user/author try destroy question" do
    sign_in(user)
    visit question_path(question)
    click_on "Delete Question"

    expect(page).to have_content "Question was successfully destroyed."
  end

  scenario "Non-authenticated user ties to destroy question" do
    visit question_path(question)
    expect(page).to_not have_content "Delete Question"
  end

  scenario "Non-author ties destroy question" do
    sign_in(non_author)
    visit question_path(question)

    expect(page).to_not have_content "Delete Question"
  end
end
