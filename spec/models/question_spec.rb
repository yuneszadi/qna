require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }

  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions) }

  it { should validate_presence_of :title}
  it { should validate_presence_of :body}

  it { should accept_nested_attributes_for :attachments }

  context "reputation" do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it_behaves_like 'calculate reputation'
  end
end
