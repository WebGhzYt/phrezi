class CreatePatronCarts < ActiveRecord::Migration
  def change
    create_table :patron_carts do |t|
    	t.integer :total
      t.integer :loyal_patron_id
      t.integer :booster_id
      t.integer :quantity
      t.timestamps
    end
  end
end
