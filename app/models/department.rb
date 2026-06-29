class Department < ApplicationRecord
    has_many :categories, dependent: :restrict_with_error
    has_many :users, dependent: :nullify
end
