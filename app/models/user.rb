class User < ApplicationRecord
  attr_accessor :login
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations
  validates_presence_of :username
  validates_uniqueness_of :username
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
 end

  def author_of?(entity)
    id == entity.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    user = User.where(email: auth.info.email).first
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      username = auth.info.email.split('@')[0]
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: auth.info.email, username: username, password: password, password_confirmation: password )
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    end

    user
  end

end
