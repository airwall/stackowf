require 'features_helper'

feature "User sign up", '
  In order to able to ask question
  As an User
  I want to be able to sign up
' do
  given(:user) { create(:user) }

  scenario "Non-registered user can sign up" do
    visit new_user_registration_path
    fill_in "Username", with: "NewUsernameTest"
    fill_in "Email", with: "new@test.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_on "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario "New user can't sign up with wrong parrameters" do
    visit new_user_registration_path
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_on "Sign up"

    expect(page).to have_content "Email can't be blank"
  end

  scenario "Registered user try to sign up" do
    sign_in(user)

    visit new_user_registration_path
    expect(page).to have_content "You are already signed in."
  end
end
