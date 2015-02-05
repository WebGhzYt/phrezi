class AddColumnClosedToEstablishmentHour < ActiveRecord::Migration
  def change
  	add_column :establishment_hours, :closed, :boolean, :default => false
  end
end
