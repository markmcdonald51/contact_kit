class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers, :force => true do |t|
      t.string :number 
      t.references :phoneable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_numbers
  end
end
