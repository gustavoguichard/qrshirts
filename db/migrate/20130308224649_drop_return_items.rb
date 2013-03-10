class DropReturnItems < ActiveRecord::Migration
  def up
    drop_table :return_authorizations
    drop_table :return_conditions
    drop_table :return_items
    drop_table :return_reasons
  end

  def down
    create_table :return_reasons do |t|
      t.string :label
      t.string :description
    end
    create_table :return_conditions do |t|
      t.string :label
      t.string :description
    end
    create_table :return_items do |t|
      t.integer :return_authorization_id, :null => false
      t.integer :order_item_id,           :null => false
      t.integer :return_condition_id
      t.integer :return_reason_id
      t.boolean :returned, :default => false
      t.integer :updated_by

      t.timestamps
    end
    create_table :return_authorizations do |t|
      t.string :number#,         :null => false
      t.decimal :amount,          :precision => 8, :scale => 2, :null => false
      t.decimal :restocking_fee,  :precision => 8, :scale => 2,                 :default => 0
      t.integer :order_id,      :null => false
      t.integer :user_id,       :null => false
      t.string :state,          :null => false
      t.integer :created_by
      t.boolean :active,                                                        :default => true

      t.timestamps
    end
    add_index :return_authorizations, :number
    add_index :return_authorizations, :order_id
    add_index :return_authorizations, :user_id
    add_index :return_authorizations, :created_by
    add_index :return_items, :return_authorization_id
    add_index :return_items, :order_item_id
    add_index :return_items, :return_condition_id
    add_index :return_items, :return_reason_id
    add_index :return_items, :updated_by
  end
end
