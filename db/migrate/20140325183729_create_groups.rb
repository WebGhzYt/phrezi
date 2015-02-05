class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, index: true
      t.string :phone
      t.references :address, index: true

      t.timestamps
    end
  end
end
