require 'rails_helper'

feature 'User sign out', %q{
  In order to able to ask question
  As an User
  I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
    click_on 'Sign Out'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign out' do
    visit questions_path
    expect(page).to_not have_content 'Sign Out'
  end
end
