class IssueUpdatePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      user.admin? ? scope.all : scope.none
    end
  end
end
