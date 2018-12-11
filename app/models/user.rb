class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable,
         omniauth_providers: [:vkontakte, :github]

  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_question, through: :subscriptions, source: :question

  def author_of?(object)
    object.user_id == self.id
  end

  def subscribe?(object)
    object.subscriptions.where(user_id: self.id).exists?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = set_email(auth)
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation_notification!
      user.save!
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  protected

  def self.set_email(auth)
    unless auth.info[:email].blank?
      auth.info[:email]
    else
      "#{auth.provider + auth.uid.to_s}@temporary.com"
    end
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end


end
