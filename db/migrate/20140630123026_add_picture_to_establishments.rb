class AddPictureToEstablishments < ActiveRecord::Migration
  def change
  	change_table :establishments do |t|
      t.attachment :picture
    end
  end
end
