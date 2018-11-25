require_relative 'acceptance_helper'

 feature 'Sign Up New User', %q{
  In order to be able to authorize
  I want to be able to sign up
} do

  scenario 'Unregistered user wants to register' do
    sign_up

    expect(page).to have_content 'message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
  end
end
