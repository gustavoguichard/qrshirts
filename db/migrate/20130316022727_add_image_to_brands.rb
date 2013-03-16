class AddImageToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :image_id, :string
    add_column :brands, :featured, :boolean, default: false, null: false
  end
end
