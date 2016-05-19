require "features_helper"

feature "User sign in", '
  In order to able to ask question
  As an User
  I want to be able to sign in
' do
  given(:user) { create(:user) }

  scenario "Registered user try to sign in" do
    sign_in(user)

    expect(page).to have_content "Signed in successfully."
    expect(current_path).to eq root_path
  end

  scenario "Non-registered user try to sign in" do
    visit new_user_session_path
    fill_in "Login", with: "wrong@test.com"
    fill_in "Password", with: "12345678"
    click_on "Sign in"

    expect(page).to have_content "Invalid Login or password"
    expect(current_path).to eq new_user_session_path
  end
end
