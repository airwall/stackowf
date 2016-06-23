class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, :user_id, presence: true

  def need_confirm?
    providers = ["twitter"]
    providers.include?(provider) && !confirmed?
  end
end
