class IssueUpdatesController < ApplicationController
    before_action :authenticate_user!

    def index
        @issue_updates = policy_scope(IssueUpdate).order(created_at: :desc)
    end
end
