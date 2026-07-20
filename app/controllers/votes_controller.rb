class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_issue

  def create
    @vote = @issue.votes.build(user: current_user)
    authorize @vote
    @vote.save
    render json: { voted: true, count: @issue.reload.votes_count }
  end

  def destroy
    @vote = @issue.votes.find_by!(user: current_user)
    authorize @vote
    @vote.destroy
    render json: { voted: false, count: @issue.reload.votes_count }
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end
end