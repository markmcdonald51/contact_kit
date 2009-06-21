class IpAddress < ActiveRecord::Base
  acts_as_mappable

  before_create :geocode_ip
  validates_presence_of :ip  

  validates_format_of :ip, 
  	:with => /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/o

  named_scope :within_network, lambda {|*args| {
    :conditions =>['ip like ?', 
      "#{(args.blank? ? ip : args.first).split('.')[0..2].join('.')}.%"   ]}}

  belongs_to :ipable, :polymorphic => true  

=begin
  define_index do   
    indexes ip
    has created_at
    has events(:company_id),    :as => :company_ids
    has events(:event_type_id), :as => :event_type_ids
    set_property :match_mode => :extended 

    has 'RADIANS(lat)', :as => :lat, :type => :float
    has 'RADIANS(lng)', :as => :lng, :type => :float   
  end  
=end  

  def ips_in_network
    self.class.within_network(ip)
  end

  def geocode_ip
    location = GeoKit::Geocoders::IpGeocoder.geocode(ip)
    if location.success
      %w(lat lng street_address city country_code).each do |field|
        self[field] = location.send(field.to_sym)
      end
      self.region = location.state
      self.success_geocode = location.success
    end
  end

  def ip=(value)
    write_attribute :ip, (!value.blank? ? IpAddress.sanitize(value): nil)   
  end


  def self.sanitize(value)
    unless value.blank?
      value.gsub!(/\.+/, '.')
      value.gsub!(/[^\d\.]/o, '') 
      if (value =~ /^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$/o)
      	#value.standardize =~ /^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$/o
      	return "#{$1}.#{$2}.#{$3}.#{$4}"
      end
      return ''
    end
  end
  
  def label
    ip
  end
  
end
