class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities(user)
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities(user)
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can :destroy, Attachment, attachable: { user_id: user.id }
    can_manage_votes

    can :find_best_answer, Answer do |answer|
      user.author_of?(answer.question)
    end
  end

  private

  def can_manage_votes
    can [:like, :dislike], [Question, Answer] do |entity|
      !user.author_of?(entity)
    end
  end
end
