module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def like
    votes.create!(user: current_user, value: 1) if possible_to_vote?
  end

  def dislike
    votes.create!(user: current_user, value: -1) if possible_to_vote?
  end

  def rating
    votes.sum(:value)
  end

  private

  def possible_to_vote?
    !current_user.author_of?(self) && !votes.exists?(user: current_user)
  end
end
