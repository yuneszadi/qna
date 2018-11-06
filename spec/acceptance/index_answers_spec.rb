require_relative 'acceptance_helper'

feature 'Show question with answers list', %q{
  In order to find out
  the answer to the question
  as an authenticated user,
  I want to see all the answers
  to the question
} do

  given(:user) { create(:user)}
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Autheticated user wants to see a question with answers for it' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
