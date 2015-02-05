class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
    	t.string :name
    	t.datetime :start_date
      t.datetime :end_date
      t.decimal :payout
      t.integer :finish_points
      t.references :establishment, index: true
      t.timestamps
    end
  end
end
