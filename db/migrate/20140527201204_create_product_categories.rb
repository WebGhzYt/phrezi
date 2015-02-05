class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :name
      t.integer :default_points
      t.belongs_to :establishment
      t.timestamps
    end
  end
end
