class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category
      t.references :establishment
      t.timestamps
    end
  end
end
