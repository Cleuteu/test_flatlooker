class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.integer :surface
      t.integer :price
      t.integer :latitude
      t.integer :longitude

      t.timestamps
    end
  end
end
