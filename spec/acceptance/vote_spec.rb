require_relative 'acceptance_helper'
feature 'Vote', %q{
  I order to vote to resource
  As an authenticated user
  I want to be able to see its rating
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    before { sign_in(user) }
    scenario 'tries to like not his question', js: true do
      visit question_path(question)
      click_on 'like'
      expect(page).to have_content 1
    end

    scenario 'tries to dislike not his question', js: true do
      visit question_path(question)
      click_on 'dislike'
      expect(page).to have_content -1
    end
  end

  scenario 'Author of question does not see the voting links' do
    sign_in(author)
    visit question_path(question)
    expect(page).to_not have_link 'like'
    expect(page).to_not have_link 'dislike'
    expect(page).to have_content question.rating
  end

  scenario 'Non-authenticated user does not see the voting links' do
    visit question_path(question)
    expect(page).to_not have_link 'like'
    expect(page).to_not have_link 'dislike'
    expect(page).to have_content question.rating
  end
end
