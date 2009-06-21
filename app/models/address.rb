class Address < ActiveRecord::Base
  attr_accessible :street_address, :postal_code
  validates_presence_of :street_address, :postal_code 
  
  belongs_to :addressable, :polymorphic => true  
   
  belongs_to :city
  has_one :region,  :through => :city
  has_one :country, :through => :city
  
  validate :valid_address, :unless => Proc.new{|addr| 
    addr.street_address.blank? || addr.postal_code.blank?}
    
=begin 
  # thinking_sphinx index
  define_index do
    indexes street_address
    indexes postal_code    
    #has city_id, region_id, country_id #, created_at 
  end
=end    
  
  def valid_address
    @address_string ||= [:street_address, :postal_code].map{|f| self.send(f)}.join(',')
    
    res=Geokit::Geocoders::GoogleGeocoder.geocode(@address_string)
    
    if res.success && res.precision.to_sym == :address

      self.street_address = res.street_address.upcase
      self.postal_code 	= res.zip.gsub(/\s+/,'')     
      self.lat = res.lat
      self.lng = res.lng
      
      country = Country.find_by_iso2(res.country_code)
      region = country.regions.find_or_create_by_code(res.state)
      city = region.cities.find_or_create_by_name_and_country_id(res.city, country.id)   
      self.city = city

    elsif military_address?
      self.city = Country.find_by_iso2(res.country_code).regions.
          find_by_code(res.state).cities.find_by_name(res.city)
      return true 
    else
      errors.add_to_base('Sorry the address is not valid')
    end  
  end       

  def military_address?
    return false if region.blank? || city.blank? || postal_code.blank?
    
    (%w(ae aa ap).include?(region.name.try(:downcase)) and 
    	postal_code =~ /^0/ and
    	%w(apo fpo).include?(city.name.downcase)) 
  end
  
  
  def label
    "#{street_address} #{city.try(:name)} #{region.try(:name)}"
  end
    
  
end
