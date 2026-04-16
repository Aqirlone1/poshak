class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: %i[show edit update destroy toggle_active toggle_featured]

  def index
    @q = Product.includes(:category).ransack(params[:q])
    @products = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
  end

  def new
    @product = Product.new(active: true)
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    if @product.save
      attach_uploaded_images(@product)
      redirect_to admin_product_path(@product), notice: "Product created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      attach_uploaded_images(@product)
      redirect_to admin_product_path(@product), notice: "Product updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product
    @product.destroy
    redirect_to admin_products_path, notice: "Product deleted."
  end

  def toggle_active
    authorize @product
    @product.update(active: !@product.active?)
    redirect_to admin_products_path, notice: "Product active state updated."
  end

  def toggle_featured
    authorize @product
    @product.update(featured: !@product.featured?)
    redirect_to admin_products_path, notice: "Product featured state updated."
  end

  private

  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :slug, :description, :price, :compare_at_price, :sku, :category_id, :gender, :brand, :material,
                                    :care_instructions, :active, :featured, :position)
  end

  def attach_uploaded_images(product)
    files = params.dig(:product, :uploaded_images) || params.dig("product", "uploaded_images")
    files = Array(files).reject(&:blank?)
    return if files.blank?

    base_position = product.product_images.maximum(:position).to_i
    files.each_with_index do |file, index|
      image = product.product_images.build(
        position: base_position + index + 1,
        alt_text: product.name
      )
      image.image.attach(file)
      image.save!
    end
  end
end
