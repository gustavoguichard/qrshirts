class RemoveColumnsFromImage < ActiveRecord::Migration
  def up
    add_column    :images, :image_id, :string, null: false, default: ''
    add_column    :images, :product_id, :integer, null: false
    remove_column :images, :imageable_id
    remove_column :images, :imageable_type
    remove_column :images, :image_height
    remove_column :images, :image_width
    remove_column :images, :photo_file_name
    remove_column :images, :photo_content_type
    remove_column :images, :photo_file_size
    remove_column :images, :photo_updated_at
    add_index     :images, :product_id
  end

  def down
    remove_column :images, :image_id
    remove_column :images, :product_id
    add_column    :images, :imageable_id, :integer
    add_column    :images, :imageable_type, :string
    add_column    :images, :image_height, :integer
    add_column    :images, :image_width, :integer
    add_column    :images, :photo_file_name, :string
    add_column    :images, :photo_content_type, :string
    add_column    :images, :photo_file_size, :integer
    add_column    :images, :photo_updated_at, :datetime
    add_index     :images, :imageable_id
    add_index     :images, :imageable_type
  end
end
