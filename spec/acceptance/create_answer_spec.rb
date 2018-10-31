require 'rails_helper.rb'
feature 'Create answer on question page', %q{
  To answer the question
  as an authenticated user,
  I want to see the form on the question page
} do

  given(:user) { create(:user) }
  let(:question) { create(:question) }

  scenario 'Authenticated user creates an answer' do
    body = 'Test Answer Body'
    sign_in(user)
    visit question_path(question)
    fill_in 'Body' , with: body
    click_on 'Create answer'
    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Un-authenticated user creates answer' do
    visit question_path(question)
    click_on 'Create answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
