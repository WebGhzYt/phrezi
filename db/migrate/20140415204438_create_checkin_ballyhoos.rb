class CreateCheckinBallyhoos < ActiveRecord::Migration
  def change
    create_table :checkin_ballyhoos do |t|
      t.boolean :include_friends
      t.boolean :friends_sync
      t.integer :total_checkin_qty
      t.integer :point_value
      t.datetime :ballyhoo_start
      t.datetime :ballyhoo_end
      t.date :end_repeat
      t.references :establishment, index: true

      t.timestamps
    end
  end
end
