class CreateQweries < ActiveRecord::Migration[5.0]
  def change
    create_table :qweries do |t|
      t.string :todofuken
      t.string :shikugun
      t.string :chomei  
      t.string :type
      t.string :station
      t.integer :minute
      t.decimal :price
      t.string :fee
      t.string :madori
      t.decimal :size
      t.string :floor
      t.integer :comp_year

      t.timestamps
    end
  end
end
