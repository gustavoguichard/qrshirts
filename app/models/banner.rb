# == Schema Information
#
# Table name: banners
#
#  id         :integer          not null, primary key
#  image_id   :string(255)      not null
#  link_url   :string(255)      not null
#  starts_at  :datetime         default(2013-03-16 17:02:50 UTC), not null
#  ends_at    :datetime         default(2013-03-16 17:02:50 UTC), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Banner < ActiveRecord::Base
  attr_accessible :starts_at, :ends_at, :image_id, :link_url
  validates :starts_at, :ends_at, :image_id, :link_url, presence: true

  scope :active, where("starts_at < ? AND ends_at > ?", Time.now, Time.now)

  def image(size = :home)
    case size
      when :thumb   then FlickRaw.url_t(photo_info)
      when :home    then FlickRaw.url_o(photo_info)
      when :small   then FlickRaw.url_n(photo_info)
      else FlickRaw.url(photo_info)
    end
  rescue
    nil
  end

  def display_start_time(format = :us_date)
    starts_at ? I18n.localize(starts_at, format: format) : 'N/A'
  end

  def display_expires_time(format = :us_date)
    ends_at ? I18n.localize(ends_at, format: format) : 'N/A'
  end

private

  def photo_info
    flickr.photos.getInfo(photo_id: self.image_id) rescue nil
  end

end
