require "features_helper"

feature "User can vot question", '
  As an authenticated user
  I want to vote question
' do
  given(:non_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question2) { create(:question, user: user) }
  given(:voteup) { create(:vote, score: 1, votable: question, user: non_author) }
  given(:votedown) { create(:vote, score: -1, votable: question2, user: non_author) }

  scenario "non authenticated user can't vote answer", js: true do
    question.reload
    visit question_path(question)
    expect(page).to have_content question.body
    within "#votable_question_#{question.id}" do
      expect(page).to have_content "0"
      expect(page).to_not have_css ".glyphicon.glyphicon-plus"
      expect(page).to_not have_css ".glyphicon.glyphicon-minus"
    end
  end

  scenario "Author can't vote his answer", js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.body
    within "#votable_question_#{question.id}" do
      expect(page).to have_content "0"
      expect(page).to_not have_css ".glyphicon.glyphicon-plus"
      expect(page).to_not have_css ".glyphicon.glyphicon-minus"
    end
  end

  context "Non Author" do
    scenario "Non author can vote up answer", js: true do
      question.reload
      sign_in(non_author)
      visit question_path(question)
      expect(page).to have_content question.body
      within "#votable_question_#{question.id}" do
        expect(page).to have_content "0"
        expect(page).to have_css ".glyphicon.glyphicon-plus"
        expect(page).to have_css ".glyphicon.glyphicon-minus"

        find(".glyphicon.glyphicon-plus").click
        expect(page).to have_content "1"
      end
    end

    scenario "Non author can vote down answer", js: true do
      question.reload
      sign_in(non_author)
      visit question_path(question)
      expect(page).to have_content question.body
      within "#votable_question_#{question.id}" do
        expect(page).to have_content "0"
        expect(page).to have_css ".glyphicon.glyphicon-plus"
        expect(page).to have_css ".glyphicon.glyphicon-minus"

        find(".glyphicon.glyphicon-minus").click
        expect(page).to have_content "-1"
      end
    end

    scenario "Non author can cancel answer when answer it's up", js: true do
      question.reload
      sign_in(non_author)
      visit question_path(question)
      expect(page).to have_content question.body
      within "#votable_question_#{question.id}" do
        expect(page).to have_content "0"
        expect(page).to have_css ".glyphicon.glyphicon-plus"
        expect(page).to have_css ".glyphicon.glyphicon-minus"
        find(".glyphicon.glyphicon-plus").click
        expect(page).to have_content "0"
      end
    end

    scenario "Non author can cancel answer when answer it's down", js: true do
      question2.reload
      sign_in(non_author)
      visit question_path(question2)
      within "#votable_question_#{question2.id}" do
        expect(page).to have_content "0"
        expect(page).to have_css ".glyphicon.glyphicon-plus"
        expect(page).to have_css ".glyphicon.glyphicon-minus"
        find(".glyphicon.glyphicon-minus").click
        expect(page).to have_content "0"
      end
    end
  end
end
