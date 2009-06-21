class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.references :country, :null => false
      t.references :region, :null => false
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :timezone
      t.integer :dma_id
      t.string :county
      t.string :code

      t.timestamps
    end
    add_index :cities, :name  
    add_index :cities, [:region_id, :country_id]
    add_index :cities, [:latitude, :longitude]
    
    system "rsync -ruv #{RAILS_ROOT}/db/migrate/20090324205333_places_data/ /tmp"

    execute "LOAD DATA INFILE '/tmp/Countries.txt' INTO TABLE countries 
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;"  
  
   # execute "LOAD DATA INFILE '/tmp/Regions.txt' INTO TABLE regions  
   #   FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;"  
  
    # execute "LOAD DATA INFILE '/tmp/Cities.txt' INTO TABLE cities 
    #  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;"  
      
    # Armed Forces were not included in database so add them in...  
    country = Country.find_by_iso2('us')
    {'AA' => 'Army Post Office/All Countries',
     'AE' => 'Army Post Office/Europe', 
     'AP' => 'Army Post Office/Pacific'}.each do |k,v|

        r = Region.create(:code => k, :name => v, :country_id => country.id)
        
        {'APO' => 'Army Post Office', 
        'FPO' => 'Fleet Post Office'}.each {|rk,rv|
           r.cities <<  City.new(:country_id => country.id, :name => rk )
         }
      end  
  end    

  def self.down
    drop_table :cities
  end
end
