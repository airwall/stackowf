class User < ApplicationRecord
  attr_accessor :login
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  validates_presence_of :username
  validates_uniqueness_of :username
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

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
    provider = auth[:provider]
    uid = auth[:uid].to_s
    authorization = Authorization.find_by(provider: provider, uid: uid)
    return authorization if authorization

    email = auth[:info][:email]
    return nil if email.nil?
    user = User.find_by(email: email)
    if !user
      username = auth[:info][:email].split('@')[0]
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, username: username, password: password, password_confirmation: password )
    end
      user.authorizations.create!(provider: provider, uid: uid, confirmation_hash: Devise.friendly_token[0, 20])
  end
end
