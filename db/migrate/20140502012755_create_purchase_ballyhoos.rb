class CreatePurchaseBallyhoos < ActiveRecord::Migration
  def change
    create_table :purchase_ballyhoos do |t|
      t.integer :purchase_type
      t.integer :item_id
      t.integer :point_adjustment
      t.string :title
      t.text :description
      t.datetime :ballyhoo_start
      t.datetime :ballyhoo_end
      t.date :end_repeat
      t.integer :repeat_type
      t.references :establishment, index: true

      t.timestamps
    end
  end
end
