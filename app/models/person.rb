class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name
  validates_presence_of :first_name, :last_name
  
  belongs_to :personable, :polymorphic => true  

  
  def label
    "#{first_name} #{last_name}"
  end
end
