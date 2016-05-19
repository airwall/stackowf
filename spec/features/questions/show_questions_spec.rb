require 'features_helper'

feature "All users can see list of questions" do
  given(:question) { create_list(:question, 5) }
  given(:user) { create(:user) }

  scenario "Non-Authorized user can see questions" do
    visit root_path(question)
    click_on "Questions"
    question.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario "Authorized user can see questions" do
    sign_in(user)
    visit root_path(question)
    click_on "Questions"
    question.each do |question|
      expect(page).to have_content question.title
    end
  end
end
