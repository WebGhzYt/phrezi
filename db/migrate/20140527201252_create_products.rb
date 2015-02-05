class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :cost
      t.decimal :price
      t.boolean :active
      t.belongs_to :product_category
      t.timestamps
    end
  end
end
