class Category < ApplicationRecord
    belongs_to :department
    has_many :issues, dependent: :restrict_with_error
end
