require 'rails_helper'

feature 'All users can see list of questions' do
  given(:question) { create(:question) }

  scenario 'I see questions' do
    visit root_path(question)
    click_on 'Questions'
    expect(page).to have_content question.title
  end
end
