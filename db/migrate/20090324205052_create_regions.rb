class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.references :country, :null => false
      t.string :name
      t.string :code
      t.string :adm1code

      t.timestamps
    end
    add_index :regions, [:country_id, :name, :code]
  end

  def self.down
    drop_table :regions
  end
end
