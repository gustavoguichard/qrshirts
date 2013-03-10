class AddShipmentIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipment_id, :integer
    add_index :orders, :shipment_id
  end
end
