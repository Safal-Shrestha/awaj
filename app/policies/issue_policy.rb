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
    user.present? && (user == record.user || user.admin?)
  end

  def reopen?
    user.present? && (user == record.user || user.admin?)
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
