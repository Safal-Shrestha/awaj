class IssuesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_issue, only: %i[ show acknowledge start_progress resolve verify reopen ]

  # GET /issues or /issues.json
  def index
    @issues = policy_scope(Issue).order(:created_at)
  end

  # GET /issues/1 or /issues/1.json
  def show
    authorize @issue
  end

  # GET /issues/new
  def new
    @issue = Issue.new
    authorize @issue
    @departments = Department.order(:department_name)
    @categories = Category.order(:name)
  end

  # POST /issues or /issues.json
  def create
    @issue = Issue.new(issue_params)
    authorize @issue

    @issue.user = current_user

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: "Issue was successfully created." }
        format.json { render :show, status: :created, location: @issue }
      else
        @departments = Department.order(:department_name)
        @categories = Category.order(:name)
        puts @issue.errors.full_messages
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @issue.errors, status: :unprocessable_content }
      end
    end
  end

  def acknowledge
    perform_transition!(:acknowledge)
  end

  def start_progress
    perform_transition(:start_progress)
  end

  def resolve
    perform_transition(:resolve)
  end

  def verify
    perform_transition(:verify)
  end

  def reopen
    perform_transition(:reopen)
  end

  private

    def perform_transition!(event)
      authorize @issue, "#{event}>\?"

      if @issue.public_send("#{event}!")
        redirect_to @issue, notice: "Issue #{event.to_s.humanize.downcase} succeeded."
      end

    rescue AASM::InvalidTransiton
      redirect_to @issue, alert: "This issue can't be #{event.to_s.humanize.downcase}d from it current state."
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:title, :description, :category_id, :anonymous)
    end
end
