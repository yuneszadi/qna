class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  after_create :update_reputation
  after_create :create_subscription

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end

  def create_subscription
    subscriptions.create(user: user)
  end
end
