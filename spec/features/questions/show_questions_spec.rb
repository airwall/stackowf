require "rails_helper"

feature "All users can see list of questions" do
  given(:question) { create_list(:question, 5) }

  scenario "I see questions" do
    visit root_path(question)
    click_on "Questions"
    expect(page).to have_content "Question 4"
  end
end
