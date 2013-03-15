class AddTaxRateToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :tax_rate, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    remove_column :orders, :bill_address_id
  end
  def down
    remove_column :orders, :tax_rate
    add_column :orders, :bill_address_id, :integer
  end
end
