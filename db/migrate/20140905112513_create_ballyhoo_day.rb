class CreateBallyhooDay < ActiveRecord::Migration
  def change
    create_table :ballyhoo_days do |t|
      t.string :day
      t.integer :repeat_type
      t.date :end_repeat
      t.integer :ballyhoo_id

      t.timestamps
    end
  end
end
