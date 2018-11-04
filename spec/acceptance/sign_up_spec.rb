require 'rails_helper.rb'

 feature 'Sign Up New User', %q{
  In order to be able to authorize
  I want to be able to sign up
} do

  scenario 'Unregistered user wants to register' do
    sign_up

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
