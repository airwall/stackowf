require "features_helper"

feature "Add files to answer", %q{
  In order to illustrate my answer
  As an a answer author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario "User adds file when ask question" do
    click_on "New Answer"
    fill_in "Body", with: "NewAnswer123"
    attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
    click_on "Submit"

    within "#answer_#{answer.id}" do
      expect(page).to have_content "File#1"
    end
  end
end
