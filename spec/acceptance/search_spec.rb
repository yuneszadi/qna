require_relative 'acceptance_helper'
feature 'Search', %q{
  As an user
  I want to be able
  to search information
} do

  given!(:user) { create(:user, email: 'search@test.com') }
  given!(:question) { create(:question, body: 'search') }
  given!(:answer) { create(:answer, body: 'search') }
  given!(:comment) { create(:comment, commentable: question, body: 'search') }

  %w(Questions Answers Comments Users).each do |search_object|
    scenario "search in #{search_object}", js: true do
      ThinkingSphinx::Test.run do
        visit questions_path
        fill_in 'search_text', with: 'search'
        select search_object, from: 'search_object'
        click_on 'Search'
        expect(page).to have_content 'search'
      end
    end
  end
end
