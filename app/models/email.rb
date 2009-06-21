class Email < ActiveRecord::Base
  attr_accessible :email
 
  validates_format_of :email, 
  	:with     => Authentication.email_regex, 
  	:message  => Authentication.bad_email_message
  	  
  validate :invalid_email_server

  belongs_to :emailable, :polymorphic => true  

=begin 
  define_index do
    indexes email
    has created_at
    has events(:company_id),    :as => :company_ids
    has events(:event_type_id), :as => :event_type_ids
  end
=end

  def email=(value)
     value.gsub!(/[^\w\d@_\-\.\+]/, '')
     write_attribute :email, (value ? value : nil)   
  end
  
  def invalid_email_server
    result = nil
    if email.include?('@')
      username, server = email.split(/@/)
      result = `dig  #{server} MX  +short`
    end  
    errors.add(:email, "invalid mail server: #{server}") if result.blank?
  end
  
end
