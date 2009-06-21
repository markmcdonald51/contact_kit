class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string  :street_address, :null => false
      t.string :apartment_number 
      t.string  :postal_code, :null => false
      t.integer :city_id #, :null => false
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.references :addressable, :polymorphic => true

      t.timestamps
    end
    add_index :addresses, [:lat, :lng]
    add_index :addresses, :md5
  end
  
  def self.down
    drop_table :addresses
  end
end
