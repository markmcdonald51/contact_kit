class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people, :force => true do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.references :personable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
