require 'rails_helper'
RSpec.describe AnswerNotificationJob, type: :job do
  let(:question) { create(:question) }
  let(:subscriptions) { create_list(:subscription, 2, question: question) }
  let!(:answer) { create(:answer, question: question) }

  it "send notification to question's subs" do
    question.subscribers.each do |user|
      expect(AnswerNotificationMailer).to receive(:subscribers_notification).with(answer, user).and_call_original
    end
    
    AnswerNotificationJob.perform_now(answer)
  end
end
