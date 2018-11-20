require 'rails_helper'

RSpec.describe User do
  let!(:user) { create(:user) }
  let!(:user_question) { create(:question, user: user) }
  let!(:question) { create(:question) }

  it { should have_many(:comments) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'is author of object' do
    expect(user).to be_author_of(user_question)
  end

   it 'is not author of object' do
    expect(user).to_not be_author_of(question)
  end
end
