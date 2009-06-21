class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders, :force => true do |t|
      t.string :order_number
      t.integer :email_id
      t.integer :shipping_address_id
      t.integer :billing_address_id
      t.integer :shipping_receipient_id
      t.integer :billing_receipient_id
      t.integer :phone_number_id
      t.integer :ip_address_id
      t.decimal :order_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
