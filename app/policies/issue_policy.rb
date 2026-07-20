class IssuePolicy < ApplicationPolicy

  def create?
    user&.user?
  end

  def show?
    true
  end

  def acknowledge?
    escalate?
  end

  def start_progress?
    escalate?
  end

  def resolve?
    escalate?
  end

  def verify?
    user.present? && user&.user? && record.user_id == user.id
  end

  def reopen?
    if user.admin?
      return true
    end

    if user&.user?
      record.user_id == user.id
    end
  end

  def vote?
    user.present? && user&.user?
  end


  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  private

  def escalate?
    return false if (user.nil? || user.user?)
    return true if user.admin?
    user.moderator? && user.department_id == record.category.department_id
  end
end
