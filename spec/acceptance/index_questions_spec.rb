require_relative 'acceptance_helper'

 feature 'Show questions list', %q{
  In order to select a question
  as an authenticated user,
  I want to be able to see a list of questions
} do

  given!(:questions) { create_list(:question, 2) }

  scenario 'User wants to see questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
 end
