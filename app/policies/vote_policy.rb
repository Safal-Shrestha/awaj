class VotePolicy < ApplicationPolicy
  def create?
    user.present? && user&.user?
  end

  def destroy?
    user.present? && record.user_id == user.id
  end
end
