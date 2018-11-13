require_relative 'acceptance_helper'
 feature 'Delete files', %q{
  In order to delete files
  as an author
  I'd like to be able to delete files
} do

  given(:user) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user) }
  given!(:question_attachment) { create(:attachment, attachable: question) }
  given!(:answer_attachment) { create(:attachment, attachable: answer) }

  describe 'Author' do
    before { sign_in(user) }

    scenario 'can delete file from question', js: true do
      visit question_path(question)
      click_on 'delete'
      expect(page).to_not have_link question_attachment.file.identifier
    end

    scenario 'can delete file from answer', js: true do
      visit question_path(answer.question)
      click_on 'delete'
      expect(page).to_not have_link answer_attachment.file.identifier
    end
  end

  scenario "Non-author can't sees 'Delete' link" do
    sign_in(non_author)
    visit question_path(answer.question)
    expect(page).to_not have_link 'delete'
  end
end
