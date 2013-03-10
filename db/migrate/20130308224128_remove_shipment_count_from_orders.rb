class RemoveShipmentCountFromOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :shipments_count
  end

  def down
    add_column :orders, :shipments_count, :integer
  end
end
