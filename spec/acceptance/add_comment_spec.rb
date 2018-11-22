require_relative 'acceptance_helper'

feature 'Add comment to question', %q{
  As an authenticated user
  I want to be able to write a comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment', js: true do
      click_on 'Add comment'
      fill_in 'Comment', with: 'New comment'
      click_on 'Comment'
      expect(page).to have_content 'New comment'
    end
  end

  scenario 'Non-authenticated user tries to create comment' do
    visit question_path(question)
    expect(page).to_not have_link 'Add comment'
  end

  context 'multiple sessions' do
    scenario 'comment appears on another user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Add comment'
        fill_in 'Comment', with: 'New comment'
        click_on 'Comment'
        expect(page).to have_content 'New comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New comment'
      end
    end
  end
end
