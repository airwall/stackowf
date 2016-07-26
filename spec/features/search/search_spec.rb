require "features_helper"

feature "search and view results", :js do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:answer_comment) }
  given!(:user) { create(:user) }

  background do
    ThinkingSphinx::Test.stop
    ThinkingSphinx::Test.clear
    ThinkingSphinx::Test.start
    ThinkingSphinx::Test.index
    visit root_path
  end

  scenario "all" do
    find(".navbar-toggle").click
    find(".glyphicon.glyphicon-search").click
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment.body
    expect(page).to have_content user.email

    find(".navbar-toggle").click
    fill_in "search_query", with: question.title
    select "question", from: "search_type"
    find(".glyphicon.glyphicon-search").click
    expect(page).to have_content question.title
    expect(page).not_to have_content answer.body
    expect(page).not_to have_content comment.body
    expect(page).not_to have_content user.email

    find(".navbar-toggle").click
    fill_in "search_query", with: answer.body
    select "answer", from: "search_type"
    find(".glyphicon.glyphicon-search").click
    expect(page).not_to have_content question.title
    expect(page).to have_content answer.body
    expect(page).not_to have_content comment.body
    expect(page).not_to have_content user.email

    find(".navbar-toggle").click
    fill_in "search_query", with: comment.body
    select "comment", from: "search_type"
    find(".glyphicon.glyphicon-search").click
    expect(page).not_to have_content question.title
    expect(page).not_to have_content answer.body
    expect(page).to have_content comment.body
    expect(page).not_to have_content user.email

    find(".navbar-toggle").click
    fill_in "search_query", with: user.email
    select "user", from: "search_type"
    find(".glyphicon.glyphicon-search").click
    expect(page).not_to have_content question.title
    expect(page).not_to have_content answer.body
    expect(page).not_to have_content comment.body
    expect(page).to have_content user.email
  end
end
