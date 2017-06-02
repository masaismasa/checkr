class CreateTests < ActiveRecord::Migration[5.0]
  def change
    create_table :tests do |t|
      t.string :station
      t.string :address
      t.string :link
      t.string :minute
      t.string :price
      t.string :fee
      t.string :reisiki
      t.string :madori
      t.string :size
      t.string :floor
      t.string :age
      t.string :brand
      t.string :shop
      

      t.timestamps
    end
  end
end
