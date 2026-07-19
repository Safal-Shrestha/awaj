class CategoryPolicy < AdminManagedPolicy
    def index?
        user.moderator? || admin?
    end
end
