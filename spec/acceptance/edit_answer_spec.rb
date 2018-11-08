require_relative 'acceptance_helper'

 feature 'Edit answer', %q{
  In order to update anwer
  As an author
  I want to be to be able to edit answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "Un-authenticated user want to edit answer" do
    visit question_path(question)
    expect(page).to_not have_link 'Edit answer'
  end

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "sees link to edit" do
      expect(page).to have_link 'Edit answer'
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit answer'
      within '.answers' do
        fill_in "New answer",	with: "New answer body"
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content "New answer body"
      end
    end
  end

  scenario "Non author can't sees link to edit" do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_link 'Edit answer'
  end
end
