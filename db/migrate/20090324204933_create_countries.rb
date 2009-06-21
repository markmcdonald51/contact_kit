class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name
      t.string :fips104
      t.string :iso2
      t.string :iso3
      t.string :ison
      t.string :internet
      t.string :capitol
      t.string :map_reference
      t.string :nationality_singular
      t.string :nationality_plural
      t.string :currency
      t.string :currency_code
      t.integer :population
      t.string :title
      t.string :comment

      t.timestamps
    end
    add_index :countries, [:name, :iso2]
  end

  def self.down
    drop_table :countries
  end
end
