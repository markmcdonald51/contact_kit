
class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :email, :null => false       
      t.references :addressable, :polymorphic => true
      t.timestamps
    end
    add_index :emails, :email
  end
  
  def self.down
    drop_table :emails
  end
end
