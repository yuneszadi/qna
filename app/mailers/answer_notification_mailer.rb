class AnswerNotificationMailer < ApplicationMailer
  def subscribers_notification(answer, user)
    @question = answer.question
    @greeting = "Hi"
    @answer = answer
    mail to: user.email
  end
end
