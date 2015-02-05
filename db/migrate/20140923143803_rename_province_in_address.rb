class RenameProvinceInAddress < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :province, :state
  end

  def self.down
    rename_column :addresses, :state, :province
  end
end
