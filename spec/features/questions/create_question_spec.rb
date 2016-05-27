require "features_helper"

feature "Create question", '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
' do
  given(:user) { create(:user) }

  scenario "Authenticated user can create question" do
    sign_in(user)
    visit questions_path
    click_on "New Question"
    fill_in "Title", with: "Title"
    fill_in "Body", with: "NewQuestion123"
    click_on "Submit"

    expect(page).to have_content "Question was successfully created."
    expect(page).to have_content "NewQuestion123"
  end

  scenario "User adds files when create question", js: :true do
    sign_in(user)
    visit new_question_path

    fill_in "Title", with: "TitleQuestion"
    fill_in "Body", with: "BodyQuestion"

    click_on "Add File"
    within all(".nested-fields").last do
      attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on "Add File"
    within all(".nested-fields").last do
      attach_file "File", "#{Rails.root}/spec/features_helper.rb"
    end

    click_on "Submit"

    expect(page).to have_link "File 1"
    expect(page).to have_link "File 2"
  end

  scenario "Non-authenticated user ties to create question" do
    visit questions_path
    click_on "New Question"
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
