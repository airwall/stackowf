require "features_helper"

feature "Create Subscription" do
  given(:user) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "Authenticated user, non author of question, can create subscription and delete it", js: true do
    sign_in(non_author)
    visit question_path(question)
    click_on "Subscribe"
    expect(page).to have_content "Unsubscribe"
    click_on "Unsubscribe"
    expect(page).to have_content "Subscribe"
  end

  scenario "Authenticated user, author of question it's initial subscribed to his question and can delete subribtion", js: true do
    sign_in(user)
    visit question_path(question)
    click_on "Unsubscribe"
    expect(page).to have_content "Subscribe"
    click_on "Subscribe"
    expect(page).to have_content "Unsubscribe"
  end

  scenario "Non-Authenticated user can't create subscription", js: true do
    visit question_path(question)
    expect(page).to_not have_content "Unsubscribe"
    expect(page).to_not have_content "Subscribe"
  end
end
