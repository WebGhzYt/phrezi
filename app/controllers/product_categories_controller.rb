class ProductCategoriesController < WebApplicationController
  before_filter :set_product_category, only: [:show, :destroy, :edit, :update]

  def index
    @product_categories = current_establishment.product_categories
  end

  def new
    @product_category = current_establishment.product_categories.new
  end

  def create
    @product_category = current_establishment.product_categories.build(product_category_params)
    if @product_category.save
      redirect_to :back, notice: "Category successfully created."
    else
      redirect_to :back, flash: {error: @product_category.errors.full_messages.join(", ")}
    end
  end

  def show
    respond_with @product_category
  end

  def update
    if @product_category.update(product_category_params)
      redirect_to :back, notice:  "successfully updated category."
    else
      redirect_to :back, flash:{ error: @product_category.errors.full_messages.join(", ")}
    end
  end

  def edit
    respond_with @product_category
  end

  def destroy
    if @product_category.destroy
      redirect_to :back, notice: "Successfully deleted the product category"
    else
      redirect_to :back, notice: "Could not delete the product categroy"
    end
  end

  private
    def product_category_params
      params.require(:product_category).permit(:name, :establishment_id, :default_points)
    end

    def set_product_category
      @product_category = current_establishment.product_categories.find(params[:id])
    end
end