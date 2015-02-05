class ChangeTimeToStringInEstablishmentHours < ActiveRecord::Migration
  def up
    remove_column :establishment_hours, :open_time
    remove_column :establishment_hours, :close_time
    add_column :establishment_hours, :open_time, :time
    add_column :establishment_hours, :close_time, :time
  end

  def down
    remove_column :establishment_hours, :open_time
    remove_column :establishment_hours, :close_time
    add_column :establishment_hours, :open_time, :string
    add_column :establishment_hours, :close_time, :string
  end
end
