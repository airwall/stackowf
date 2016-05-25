require "features_helper"

feature "Add files to question", %q{
  In order to illustrate my question
  As an a question author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  bacjground do
    sign_in(user)
    visit new_question_path
  end

  scenario "User adds file when ask question" do
    click_on "New Question"
    fill_in "Title", with: "Title"
    fill_in "Body", with: "NewQuestion123"
    attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
    click_on "Submit"

    expect(page).to have_content "spec_helper.rb"
    
  end

end
