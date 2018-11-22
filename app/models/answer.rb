class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
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
end
