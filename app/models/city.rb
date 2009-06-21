class City < ActiveRecord::Base
  belongs_to :country
  belongs_to :region
  
 # acts_as_mappable  :lat_column_name => 'latitude', 
 #                   :lng_column_name => 'longitude'
                    
                    
end
