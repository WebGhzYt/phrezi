class AddTimezoneToEstablishments < ActiveRecord::Migration
  def change
  	add_column :establishments, :timezone, :string
  end
end
