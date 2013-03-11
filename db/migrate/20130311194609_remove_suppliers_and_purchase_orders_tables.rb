class RemoveSuppliersAndPurchaseOrdersTables < ActiveRecord::Migration
  def up
    drop_table :purchase_orders
    drop_table :suppliers
    drop_table :variant_suppliers
    remove_column :inventories, :count_pending_from_supplier
  end

  def down
    add_column :inventories, :count_pending_from_supplier, :integer, :default => 0
    create_table :purchase_orders do |t|
      t.integer :supplier_id,       :null => false
      t.string :invoice_number
      t.string :tracking_number
      t.string :notes
      t.string :state
      t.datetime :ordered_at,       :null => false
      t.date :estimated_arrival_on
      #t.boolean :is_received,       :null => false

      t.timestamps
    end

    add_index :purchase_orders, :supplier_id
    add_index :purchase_orders, :tracking_number

    create_table :suppliers do |t|
      t.string      :name, :null => false
      t.string      :email

      t.timestamps
    end

    create_table :variant_suppliers do |t|
      t.integer     :variant_id,                                            :null => false
      t.integer     :supplier_id,                                           :null => false
      t.decimal      :cost, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.integer      :total_quantity_supplied,            :default => 0
      t.integer      :min_quantity,                       :default => 1
      t.integer      :max_quantity,                       :default => 10000
      t.boolean     :active,                              :default => true
      t.timestamps
    end

    add_index :variant_suppliers, :variant_id
    add_index :variant_suppliers, :supplier_id
  end
end
