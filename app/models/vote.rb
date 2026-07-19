class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :issue, counter_cache: true

  validates :user_id, uniqueness: { scope: :issue_id, message: "has already voted on this issue" }
end
