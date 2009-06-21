class Order < ActiveRecord::Base
 
 =begin 
  # Add in thinking_sphinx for this index below
  define_index do
    indexes email.email
    indexes phone_number.number
    indexes ip_address.ip
    indexes shipping_address.street_address, shipping_address.postal_code
    indexes billing_address.street_address, billing_address.postal_code
    indexes shipping_receipient.first_name, shipping_receipient.last_name 
    indexes billing_receipient.first_name, billing_receipient.last_name 
  end
=end

  belongs_to :email

  belongs_to :phone_number
  belongs_to :ip_address
  
  belongs_to :shipping_address,	:class_name => 'Address'
  belongs_to :billing_address, 	:class_name => 'Address'
  
  belongs_to :shipping_receipient, :class_name => 'Person'
  belongs_to :billing_receipient, :class_name => 'Person'
    
