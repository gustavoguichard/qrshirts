class RemoveStoreCreditTable < ActiveRecord::Migration
  def up
    drop_table :store_credits
  end

  def down
    create_table :store_credits do |t|
      t.decimal  :amount, :precision => 8, :scale => 2, :default => 0.0
      t.integer  :user_id, :null => false
    end
  end
end
