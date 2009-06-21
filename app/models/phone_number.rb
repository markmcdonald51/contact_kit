class PhoneNumber < ActiveRecord::Base
  #include ActionView::Helpers::NumberHelper  

  #validates_uniqueness_of :number
  validates_presence_of :number

  def number=(value)
    write_attribute :number, (value.blank? ? \
      nil : value.gsub(/[^\d]/, '') )
  end

=begin  
  define_index do
    indexes number
    has created_at
    has events(:company_id),    :as => :company_ids
    has events(:event_type_id), :as => :event_type_ids
  end
 
 

  # this is a kind of cool feature that makes use of a google search to find a
  # given phone number... if it finds the number it will usually associate it
  # to a person. Works about 50% of the the time at least in my area.\
  # to use it add something like this at the top of this model
  # before_save :google_address

  def google_address
   require  'hpricot'
   require 'open-uri'
    root = "http://www.google.com/search?hl=en&client=firefox-a&rls=org.mozilla%3Aen-US%3Aofficial&q=#{number}&btnG=Search/"
    doc = Hpricot(open(root))
		
   	unless (search_1 = doc.search("//div[@id='res']").search('//table')[1]).blank?
			td = search_1.search('//td')
		  full_name = td[0].inner_html
			address = td[2].inner_html.gsub(/&nbsp; /, '')
	
			self.address 	= Address.new(:address_string => address) unless address.blank?
		  self.person 	= Person.new(:full_name => full_name) unless full_name.blank?

			return [full_name, address]
		end
  end
  
=end

end
