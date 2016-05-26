require "features_helper"

feature "Add files to answer", "
  In order to illustrate my answer
  As an a answer author
  I'd like to be able to attach files
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario "User adds files when add answer", js: :true do
    fill_in "Body", with: "NewAnswer123"

    click_on "Add File"
    within all('.nested-fields').last do
      attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on "Add File"
    within all('.nested-fields').last do
      attach_file "File", "#{Rails.root}/spec/features_helper.rb"
    end

    click_on "Submit"

      expect(page).to have_link 'File 1'
      expect(page).to have_link 'File 2'
  end
end
