require 'rails_helper.rb'
 feature 'Delete question', %q{
  In order to delete a question
  as an authenticated user
  I should be the author of
  this question
} do

  given!(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'The author wants to delete the question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'
     expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(current_path).to eq questions_path
  end

   scenario 'Not author wants to delete the question' do
    non_author = create(:user)
    sign_in(non_author)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
   end

   scenario 'Un-authenticated user wants to delete the answer' do
    visit question_path(question)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
