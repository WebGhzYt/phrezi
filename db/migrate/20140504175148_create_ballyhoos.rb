class CreateBallyhoos < ActiveRecord::Migration
  def change
    create_table :ballyhoos do |t|
      t.string :title
      t.text :description
      t.time :start_time
      t.time :end_time
      t.date :start_date
      t.integer :repeat_type, default: 0
      t.date :end_repeat
      t.integer :total_checkin_qty
      t.boolean :include_friends, default: false
      t.boolean :friends_sync, default: false
      t.integer :point_value
      t.integer :item_id
      t.string :ballyhoo_type
      t.references :establishment, index: true

      t.timestamps
    end
  end
end
