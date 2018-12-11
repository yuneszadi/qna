class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question
    question.subscribers.find_each do |user|
      AnswerNotificationMailer.subscribers_notification(answer, user).deliver_later
    end
  end
end
