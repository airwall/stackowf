require "features_helper"

feature "Edit question", '
  As an authenticated user
  I want to be able to edit question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "Authenticated user can edit question", js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.title

    within "#question_#{question.id}" do
      click_on "Edit Question"
      fill_in "Title", with: "NewTitle"
      fill_in "Body", with: "NewBody"
      click_on "Submit"
    end

    expect(page).to have_content "NewTitle"
  end

  scenario "Non-authenticated user ties edit question" do
    visit question_path(question)
    expect(page).to_not have_link "Edit Question"
  end

  context "Update attachments on question" do
    scenario "delete file from question", js: true do
      create(:question_attachment, attachable: question)
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content "File 1"
      click_on "Edit Question"
      within (".edit_question_form") do
        click_on "Remove File"
        click_on "Submit"
      end
      expect(page).to_not have_content "File 1"
    end

    scenario "Add file to question when edit it", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content "File 1"
      click_on "Edit Question"
      within (".edit_question_form") do
        click_on "Add File"
        attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
        click_on "Submit"
      end
      expect(page).to have_content "File 1"
    end
  end
end
