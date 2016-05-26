class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user, optional: true

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments
end
