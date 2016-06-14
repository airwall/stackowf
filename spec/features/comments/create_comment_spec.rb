require "features_helper"

feature "Create comment", '
  In order to get answer from community
  As an authenticated user
  I want to be able to add comment
' do

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:user) { create(:user) }

  scenario "Authenticated user can add comment to question", js: true do
    sign_in(user)
    visit question_path(question)
    within "#question_#{question.id}" do
      expect(page).to have_content question.body
      expect(page).to have_link "Add Comment"
      click_on "Add Comment"
      within ".comment-form" do
        fill_in "Body", with: "CommentTest"
        click_on "Submit"
      end
      expect(page).to have_content "CommentTest"
    end

  end
end
