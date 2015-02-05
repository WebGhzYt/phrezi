class MenuItemsController < WebApplicationController
  before_action :set_menu_item, only: [:show, :edit, :update, :destroy]
  
  def create
    @menu_item = current_establishment.menu_items.build(menu_item_params)
    #authorize @menu_item, :create?
    if @menu_item.save
      @menu_items = current_establishment.menu_items
    end
  end
  
  # DELETE /menu_items/1
  def destroy
    #authorize @menu_item, :destroy?
    @in_use_items = []
    current_establishment.purchase_ballyhoos.each do |ballyhoo|
      if (ballyhoo.active? || ballyhoo.upcoming?)
        @in_use_items <<  ballyhoo.product_category
      end
    end
    if @in_use_items.include?(@menu_item.name)
      respond_to do |format|
        format.js {render "/layouts/errors", locals: { full_errors: ["You can't delete the products that currently used in boosters. "] }}
      end
    else
      if @menu_item.destroy
        @menu_items = current_establishment.menu_items
        respond_to do |format|
          format.js {render "menu_items/delete"}
        end 
      end
    end
  end
  private
  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end
  def menu_item_params
    params.require(:menu_item).permit(:name,:category,:price)
  end
end
