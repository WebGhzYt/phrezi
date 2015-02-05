class RemoveDollarPointFromEstablishments < ActiveRecord::Migration
  def change
    remove_column :establishments, :dollar_point, :decimal
  end
end
