class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :by_best, -> { order(best: :desc) }

  def find_best_answer
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
