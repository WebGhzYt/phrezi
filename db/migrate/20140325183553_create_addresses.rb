class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :province
      t.string :country
      t.string :postal
      t.references :resource, :polymorphic => true
      t.timestamps
    end
  end
end
