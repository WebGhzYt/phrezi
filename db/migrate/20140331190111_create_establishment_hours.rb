class CreateEstablishmentHours < ActiveRecord::Migration
  def change
    create_table :establishment_hours do |t|
      t.references :establishment, index: true
      t.string :day
      t.string :open_time
      t.string :close_time

      t.timestamps
    end
  end
end
