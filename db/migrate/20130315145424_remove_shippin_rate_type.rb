class RemoveShippinRateType < ActiveRecord::Migration
  def up
    drop_table :shipping_rate_types
    remove_column :shipping_rates, :shipping_rate_type_id
  end

  def down
    create_table :shipping_rate_types do |t|
      t.string  :name, null: false
    end
    add_column :shipping_rates, :shipping_rate_type_id, :integer, null: false
    add_index :shipping_rates, :shipping_rate_type_id
  end
end
