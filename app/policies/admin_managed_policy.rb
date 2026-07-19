class AdminManagedPolicy < ApplicationPolicy

  def new?
    admin?
  end

  def create?
    admin?
  end
  
  def edit?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  private 

  def admin?
    return false if ( user.nil? || user.moderator? || user&.user? )
    return true if ( user.present? && user.admin? )
  end
end
