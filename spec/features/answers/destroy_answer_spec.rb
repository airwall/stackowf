require "rails_helper"

feature "Destroy Answer", '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask answer
' do
  given(:user) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question) }

  scenario "Authenticated user try destroy answer" do
    sign_in(user)
    visit question_path(question)
    question.answers do |_answer|
      click_on "Delete Answer"
      expect(page).to have_content "Answer was successfully destroyed."
    end
  end

  scenario "Non-authenticated user ties to destroy answer" do
    visit question_path(question)
    question.answers do |_answer|
      expect(page).to_not have_content "Delete Answer"
    end
  end

  scenario "Non-author ties destroy answer" do
    sign_in(non_author)
    visit question_path(question)
    question.answers do |_answer|
      click_on "Delete Answer"
      expect(page).to have_content "You cannot delete this answer."
    end
  end
end
