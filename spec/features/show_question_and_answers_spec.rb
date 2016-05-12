require "rails_helper"

feature "User can see list question and answers" do
  given(:question) { create(:question) }

  scenario "I see question" do
    visit root_path(question)
    click_on "Questions"
    click_on question.title
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'I see list of answers associated with question' do
    visit question_path(question)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end
