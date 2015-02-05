class ProductsController < WebApplicationController
  before_action :set_product, only: [:edit, :update, :destroy, :show]
  # layout "application_turbolinks"

  def index
    @products  = current_establishment.products
  end

  def new
    @product = current_establishment.products.new
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "successfully updated the product"
    else
      @products = current_establishment.products
      render action: "index", flash: {error: @product.errors.full_messages.join(", ")}
    end
  end

  def create
    @product = current_establishment.products.build(product_params)
    if @product.save
      redirect_to :back, notice: 'Product was successfully created.'
    else
      @products           = current_establishment.products
      render action: "index", flash: {error: @product.errors.full_messages.join(", ")}
    end
  end

  def destroy
    if @product.destroy
      redirect_to :back, notice: "The product has successfully been deleted."
    else
      render action: "index", flash: {error: @product.errors.full_messages.join(", ")}
    end
  end

  def edit
    respond_with @product
  end

  def show
    respond_with @product
  end

  private
    def product_params
      params.require(:product).permit(:name, :cost, :price, :product_category_id, :active)
    end

    def set_product
      @product = current_establishment.products.find(params[:id])
    end

    def init_objects_for_index
      
    end


end