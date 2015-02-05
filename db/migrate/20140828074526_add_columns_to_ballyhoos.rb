class AddColumnsToBallyhoos < ActiveRecord::Migration
  def change
  	add_column :ballyhoos, :category_id, :integer, references: :product_categories
  	add_column :ballyhoos, :min_no_of_item, :integer, default: 1
  	add_column :ballyhoos, :purchase_amount, :string
  end
end
