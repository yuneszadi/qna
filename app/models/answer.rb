class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments , as: :attachable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  scope :by_best, -> { order(best: :desc) }

  def find_best_answer
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  after_create :update_reputation
  after_create :send_notification

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end

  def send_notification
    AnswerNotificationJob.perform_later(self)
  end
end
