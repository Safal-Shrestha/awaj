class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [ :edit, :update, :destroy ]
  before_action :set_departments, only: [:new, :edit]

  # GET /categories or /categories.json
  def index
    @categories = policy_scope(Category).order(:name)
  end

  def new
    @category = Category.new
    authorize @category
  end

  def edit
    authorize @category
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)
    authorize @category

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        @departments = Department.order(:department_name)
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @category.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      authorize @category
      if @category.update(category_params)
        format.html { redirect_to @category, notice: "Category was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @category }
      else
        @departments = Department.order(:department_name)
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @category.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    authorize @category
    if @category.destroy!
      respond_to do |format|
        format.html { redirect_to departments_path, notice: "Category was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    else
      redirect_to categories_path, alert: @category.errors.full_messages.to_sentence
    end
  end

  private

  def set_category = @category ||= Category.find(params[:id])
  def category_params = params.require(:category).permit(:name, :description, :department_id)
  def set_departments
    @departments = Department.order(:department_name)
  end
end
