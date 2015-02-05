class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.references :establishment, index: true
      t.references :user, index: true
      t.datetime   :start_time
      t.datetime   :end_time
      t.integer    :total_checkin_qty
      t.boolean    :include_friends, default: false
      t.boolean    :friends_sync, default: false
      t.timestamps
    end
  end
end
