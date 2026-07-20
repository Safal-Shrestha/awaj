class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :issue, counter_cache: true
  validates :user_id, uniqueness: { scope: :issue_id, message: "has already voted on this issue" }

  after_create_commit  -> { broadcast_vote_count }
  after_destroy_commit -> { broadcast_vote_count }

  private

  def broadcast_vote_count
    issue.reload
    Turbo::StreamsChannel.broadcast_update_to(
      "issues",
      target: "vote_count_#{issue.id}",
      html: issue.votes_count.to_s
    )
  end
end