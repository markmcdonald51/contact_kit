class CreateIpAddresses < ActiveRecord::Migration
  def self.up
    create_table :ip_addresses, :force => true do |t|
      t.string :ip
      t.decimal :lat
      t.decimal :lng
      t.string :country
      t.string :city
      t.string :success_geocode
      t.string :region
      t.references :ipable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :ip_addresses
  end
end
