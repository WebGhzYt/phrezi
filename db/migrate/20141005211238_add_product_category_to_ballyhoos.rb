class AddProductCategoryToBallyhoos < ActiveRecord::Migration
  def change
    add_column :ballyhoos, :product_category, :string
  end
end
