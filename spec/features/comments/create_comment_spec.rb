require "features_helper"

feature "Create comment", '
  In order to get answer from community
  As an authenticated user
  I want to be able to add comment
' do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:user) { create(:user) }

  context "Question" do
    scenario "Authenticated user can add comment to question", js: true do
      sign_in(user)
      visit question_path(question)
      within "#question_#{question.id}" do
        expect(page).to have_content question.body
        expect(page).to have_link "add comment"
        click_on "add comment"
        fill_in "Body", with: "CommentTestQuestion"
        click_on "Submit"
        expect(page).to have_content "CommentTestQuestion"
        expect(page).to_not have_field("Body")
      end
    end

    scenario "Authenticated user can't add comment to question with invalid attr", js: true do
      sign_in(user)
      visit question_path(question)
      within "#question_#{question.id}" do
        expect(page).to have_content question.body
        expect(page).to have_link "add comment"
        click_on "add comment"
        fill_in "Body", with: nil
        click_on "Submit"
        expect(page).to have_content "Body can't be blank "
        expect(page).to have_field("Body")
      end
    end

    scenario "Non - Authenticated user can-t add comment to question", js: true do
      visit question_path(question)
      within "#question_#{question.id}" do
        expect(page).to have_content question.body
        expect(page).to_not have_link "add comment"
      end
    end
  end

  context "Answer" do
    scenario "Authenticated user can add comment to answer", js: true do
      sign_in(user)
      answer.reload
      visit question_path(question)
      within "#answer_#{answer.id}" do
        expect(page).to have_link "add comment"
        click_on "add comment"
        screenshot_and_save_page
        fill_in "Body", with: "CommentTestAnswer"
        click_on "Submit"
        expect(page).to have_content "CommentTestAnswer"
        expect(page).to_not have_field("Body")
      end
    end

    scenario "Authenticated user can't add comment to question with invalid attr", js: true do
      sign_in(user)
      answer.reload
      visit question_path(question)
      within "#answer_#{answer.id}" do
        expect(page).to have_content answer.body
        expect(page).to have_link "add comment"
        click_on "add comment"
        fill_in "Body", with: nil
        click_on "Submit"
        expect(page).to have_content "Body can't be blank "
        expect(page).to have_field("Body")
      end
    end

    scenario "Non - Authenticated user can't add comment to answer", js: true do
      answer.reload
      visit question_path(question)
      within "#answer_#{answer.id}" do
        expect(page).to have_content answer.body
        expect(page).to_not have_link "add comment"
      end
    end
  end
end
