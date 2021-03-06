require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In oreder to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path()
  end

  scenario 'User adds file to question', js: true do
    fill_in 'Title' , with: 'Test Question'
    fill_in 'Body' , with: 'Test Body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add file'
    all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

  scenario 'User can cancel adding file', js: true do
    visit new_question_path()
    fill_in 'Title' , with: 'Test Question'
    fill_in 'Body' , with: 'Test Body'
    click_on 'remove'
    expect(page).to_not have_content find('input[type="file"]')
  end
end
