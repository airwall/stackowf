class SubscriptionPolicy < ApplicationPolicy
  def destroy?
    user.present? && (user.admin? || user.id == record.user_id)
  end
end
