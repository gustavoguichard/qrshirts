class RemoveMetasFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :meta_keywords
    remove_column :products, :meta_description
  end

  def down
    add_column :products, :meta_description, :string
    add_column :products, :meta_keywords, :string
  end
end
