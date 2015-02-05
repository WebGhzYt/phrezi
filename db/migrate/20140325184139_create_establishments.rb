class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      t.string :name, index: true
      t.references :address, index: true
      t.string :phone
      t.float :gps_lat
      t.float :gps_long
      t.string :website
      t.string :facebook
      t.string :twitter
      t.references :group, index: true
      t.decimal :points_dollar
      t.string :default_currency
      t.decimal :dollar_point

      t.timestamps
    end
  end
end
