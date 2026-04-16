class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: %i[show edit update destroy toggle_active move]

  def index
    @categories = Category.includes(:children).ordered
  end

  def show
  end

  def new
    @category = Category.new(active: true)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_category_path(@category), notice: "Category created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_category_path(@category), notice: "Category updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: "Category deleted."
  end

  def toggle_active
    @category.update(active: !@category.active?)
    redirect_to admin_categories_path, notice: "Category state updated."
  end

  def move
    @category.update(position: params[:position])
    redirect_to admin_categories_path, notice: "Category order updated."
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :slug, :description, :parent_id, :position, :active)
  end
end
