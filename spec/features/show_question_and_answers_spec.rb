require 'rails_helper'

feature 'User can see list question and answers' do
  given(:question) { create(:question) }

  scenario 'I see question and answers' do
    visit root_path(question)
    click_on 'Questions'
    click_on question.title
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    # binding.pry
    question.answers do |answer|
      expect(page).to have_content answer.body
    end
  end
end
