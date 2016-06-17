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
      fill_in "Title", with: question.title
      fill_in "Body", with: question.body
      click_on "Submit"
    end

    expect(page).to have_content question.title
    expect(page).to have_content question.body
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

      expect(page).to have_css ".glyphicon.glyphicon-file"
      expect(page).to have_selector(:css, 'a[href="/uploads/attachment/file/1/spec_helper.rb"]')

      click_on "Edit Question"
      within (".edit_question_form") do
        click_on "Remove File"
        click_on "Submit"
        sleep 5
      end
      expect(page).to_not  have_selector(:css, "a[href='/uploads/attachment/file/1/spec_helper.rb']")
    end

    scenario "Add file to question when edit it", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_css ".glyphicon.glyphicon-file"
      click_on "Edit Question"
      within (".edit_question_form") do
        click_on "Add File"
        attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
        click_on "Submit"
      end
      expect(page).to have_css ".glyphicon.glyphicon-file"
      expect(page).to have_selector(:css, 'a[href="/uploads/attachment/file/1/spec_helper.rb"]')
    end
  end
end
