module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def like(user)
    votes.create!(user: user, value: 1) if possible_to_vote?(user)
  end

  def dislike(user)
    votes.create!(user: user, value: -1) if possible_to_vote?(user)
  end

  def rating
    votes.sum(:value)
  end

  private

  def possible_to_vote?(user)
    !user.author_of?(self) && !votes.exists?(user: user)
  end
end
