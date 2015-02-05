class CreateCartBoosters < ActiveRecord::Migration
  def change
    create_table :cart_boosters do |t|
      t.integer :patron_cart_id
      t.integer :booster_id
      t.integer :quantity
      t.timestamps
    end
  end
end
