class Issue < ApplicationRecord
  include AASM

  belongs_to :category
  belongs_to :user, optional: true
  has_many :votes, dependent: :delete_all
  has_many :issue_update, dependent: :delete_all

  after_create_commit -> { 
    broadcast_prepend_to "issues",
    target: "issues-list",
    partial: "issues/issue",
    locals: { issue: self, can_vote: true, voted_issue_ids: Set.new } 
  }

  delegate :department, to: :category

  attr_accessor :acting_user

  validates :user, presence: true, on: :create

  aasm column: :status do
    state :reported, initial: true
    state :acknowledged
    state :in_progress
    state :resolved
    state :verified
    state :reopened

    event :acknowledge do
      transitions from: :reported, to: :acknowledged
    end
    event :start_progress do
      transitions from: [ :acknowledged, :reopened ], to: :in_progress
    end
    event :resolve do
      transitions from: :in_progress, to: :resolved
    end
    event :verify do
      transitions from: :resolved, to: :verified
    end
    event :reopen do
      transitions from: :resolved, to: :reopened
    end

    after_all_transitions :log_status_change
  end

  after_create :log_initial_report

  def reporter_display_name
    return "Anonymous" if anonymous?
    return "Deleted User" if user.nil? || user.discarded?
    user.name
  end

  private

  def log_status_change
    issue_update.create!(
      user: acting_user,
      from_state: aasm.from_state,
      to_state: aasm.to_state
    )
  end

  def log_initial_report
    issue_update.create!(
      user: user,
      from_state: nil,
      to_state: status
    )
  end
end
