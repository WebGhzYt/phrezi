class CreateEstablishmentsLoyalPatrons < ActiveRecord::Migration
  def change
    create_table :establishments_loyal_patrons do |t|
      t.integer :establishment_id
      t.integer :loyal_patron_id

      t.timestamps
    end
  end
end
