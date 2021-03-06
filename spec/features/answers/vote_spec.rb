require "features_helper"

feature "User can vot answer", '
  As an authenticated user
  I want to vote answer
' do
  given(:non_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:answer2) { create(:answer, user: user, question: question) }
  given(:voteup) { create(:vote, score: 1, votable: answer, user: non_author) }
  given(:votedown) { create(:vote, score: -1, votable: answer2, user: non_author) }

  scenario "non authenticated user can't vote answer", js: true do
    answer.reload
    visit question_path(question)
    expect(page).to have_content answer.body
    within "#votable_answer_#{answer.id}" do
      expect(page).to have_content "0"
      expect(page).to_not have_css ".glyphicon.glyphicon-plus"
      expect(page).to_not have_css ".glyphicon.glyphicon-minus"
    end
  end

  scenario "Author can't vote his answer", js: true do
    answer.reload
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content answer.body
    within "#votable_answer_#{answer.id}" do
      expect(page).to have_content "0"
      expect(page).to_not have_css ".glyphicon.glyphicon-plus"
      expect(page).to_not have_css ".glyphicon.glyphicon-minus"
    end
  end

  context "Non Author" do
    scenario "Non author can vote up answer", js: true do
      answer.reload
      sign_in(non_author)
      visit question_path(question)
      expect(page).to have_content answer.body
      within "#votable_answer_#{answer.id}" do
        expect(page).to have_content "0"
        expect(page).to have_css ".glyphicon.glyphicon-plus"
        expect(page).to have_css ".glyphicon.glyphicon-minus"

        find(".glyphicon.glyphicon-plus").click
        expect(page).to have_content "1"
      end
    end

    scenario "Non author can vote down answer", js: true do
      answer.reload
      sign_in(non_author)
      visit question_path(question)
      expect(page).to have_content answer.body
      within "#votable_answer_#{answer.id}" do
        expect(page).to have_content "0"
        expect(page).to have_css ".glyphicon.glyphicon-plus"
        expect(page).to have_css ".glyphicon.glyphicon-minus"

        find(".glyphicon.glyphicon-minus").click
        expect(page).to have_content "-1"
      end
    end

    scenario "Non author can cancel answer when answer it's up", js: true do
      answer.reload
      sign_in(non_author)
      visit question_path(question)
      expect(page).to have_content answer.body
      within "#votable_answer_#{answer.id}" do
        expect(page).to have_content "0"
        expect(page).to have_css ".glyphicon.glyphicon-plus"
        expect(page).to have_css ".glyphicon.glyphicon-minus"
        find(".glyphicon.glyphicon-plus").click
        expect(page).to have_content "0"
      end
    end

    scenario "Non author can cancel answer when answer it's down", js: true do
      question.reload
      answer2.reload
      sign_in(non_author)
      visit question_path(question)
      within "#votable_answer_#{answer2.id}" do
        expect(page).to have_content "0"
        expect(page).to have_css ".glyphicon.glyphicon-plus"
        expect(page).to have_css ".glyphicon.glyphicon-minus"
        find(".glyphicon.glyphicon-minus").click
        expect(page).to have_content "0"
      end
    end
  end
end
