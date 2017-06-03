class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.integer :qwery
      t.string :todofuken
      t.string :shikugun
      t.string :chomei  
      t.string :type
      t.string :station
      t.string :address
      t.string :link
      t.integer :minute
      t.float :price
      t.string :fee
      t.string :reisiki
      t.string :madori
      t.float :size
      t.string :floor
      t.integer :age
      t.string :brand
      t.string :shop
      

      t.timestamps
    end
  end
end
