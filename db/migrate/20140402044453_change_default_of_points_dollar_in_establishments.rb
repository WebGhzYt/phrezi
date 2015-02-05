class ChangeDefaultOfPointsDollarInEstablishments < ActiveRecord::Migration
  def up
    rename_column :establishments, :points_dollar, :point_dollar
    change_column_default :establishments, :point_dollar, 1
  end

  def down
    rename_column :establishments, :point_dollar, :points_dollar
    change_column_default :establishments, :points_dollar, nil
  end
end
