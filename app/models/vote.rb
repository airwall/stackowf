class Vote < ApplicationRecord

  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user, optional: true

  validates :user_id, :votable_id, :votable_type, presence: true
  validates :votable_id, uniqueness: { scope: [:votable_type, :user_id] }
  validates :score, inclusion: { in: [1, -1] }
end
