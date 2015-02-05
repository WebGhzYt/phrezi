class CreateLoyalPatrons < ActiveRecord::Migration
  def change
    create_table :loyal_patrons do |t|
      t.string :name
      t.integer :income
      t.integer :points
      t.float :credit
      t.string :facebook
      t.string :twitter
      t.string :email
      t.timestamps
    end
  end
end
