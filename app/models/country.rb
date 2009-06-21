class Country < ActiveRecord::Base
  has_many :regions 
  has_many :cities, :through => :regions
  
# def to_param
#    iso2.downcase
# end


end
