require "features_helper"

feature "User can edit his answer", '
  In order to change inaccurate answer
  As an authenticated user
  I want to edit my answer
' do
  given(:non_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }

  scenario "authenticated user edit his answer", js: true do
    sign_in(user)
    answer.reload
    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on "Edit"
      fill_in "Body", with: "Edited answer"
      click_on "Submit"
      expect(page).to have_content "Edit"
    end
  end

  scenario "authenticated user edit another's answer", js: true do
    sign_in(non_author)
    answer.reload
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to_not have_link "Edit"
    end
  end

  scenario "non-authenticated user edit answer", js: true do
    answer.reload
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to have_content answer.body
      expect(page).to_not have_link "Edit"
    end
  end

  context "Update attachments on answer" do
    scenario "delete file from answer", js: true do
      create(:answer_attachment, attachable: answer)
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content "spec_helper.rb"
      expect(page).to have_selector(:css, 'a[href="/uploads/attachment/file/1/spec_helper.rb"]')

      click_on "Edit"
      within "#answer_#{answer.id}" do
        click_on "Remove File"
        click_on "Submit"
      end
      expect(page).to_not have_content "spec_helper.rb"
    end

    scenario "Add file to answer when edit it", js: true do
      sign_in(user)
      answer.reload
      visit question_path(question)

      within "#answer_#{answer.id}" do
        expect(page).to_not have_content "spec_helper.rb"

        click_on "Edit"
        click_on "Add File"
        within all(".nested-fields").last do
          attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
        end
        click_on "Submit"
        expect(page).to have_content "spec_helper.rb"
        expect(page).to have_selector(:css, 'a[href="/uploads/attachment/file/1/spec_helper.rb"]')
      end
    end
  end
end
