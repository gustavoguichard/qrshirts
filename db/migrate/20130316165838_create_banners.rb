class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :image_id, null: false
      t.string :link_url, null: false
      t.datetime :starts_at, null: false, default: Time.now
      t.datetime :ends_at, null: false, default: Time.now
      t.timestamps
    end
  end
end
