class CategoryPolicy < AdminManagedPolicy
    def index?
        user.modertor? || admin?
    end
end
