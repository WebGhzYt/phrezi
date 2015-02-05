class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.references :establishment, index: true
      t.string :name
      t.string :category
      t.decimal :price

      t.timestamps
    end
  end
end
