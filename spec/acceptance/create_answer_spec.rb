require_relative 'acceptance_helper'

feature 'Create answer on question page', %q{
  To answer the question
  as an authenticated user,
  I want to see the form on the question page
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

   scenario 'Authenticated user creates an valid answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body' , with: answer.body
    click_on 'Create answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content answer.body
  end

   scenario 'Un-authenticated user creates answer', js: true do
    visit question_path(question)
    expect(page).to have_content 'You need to sign in or sign up to answer the question.'
  end

  scenario 'Authenticated user creates invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Create answer'
    expect(page).to have_content "Body can't be blank"
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user2') do
        sign_in(user2)
        visit question_path(question)
      end

       Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        fill_in 'Body' , with: 'Answer Body'
        click_on 'Create answer'
         expect(page).to have_content 'Answer Body'
      end

       Capybara.using_session('user2') do
         expect(page).to have_content 'Answer Body'
      end
    end
  end

end
