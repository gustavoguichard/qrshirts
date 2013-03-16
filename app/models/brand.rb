# The BRANDS table represents...  BRANDS!!!
#
# For now Brand is just a label added to some descriptive fields.  The only field is Name
# and hence the variants should use a method called brand_name and cache the result and hence one less DB query for this name.

# == Schema Information
#
# Table name: brands
#
#  id   :integer          not null, primary key
#  image :string
#  name :string(255)
#

class Brand < ActiveRecord::Base

  has_many :variants
  has_many :products

  validates :name,  presence: true, length: { maximum: 255 }, uniqueness: true
  validates :image_id, presence: true

  scope :bg_choosen, where(featured: true)

  def image(size = 's')
    unless image_id.nil?
      case size
        when 's' then FlickRaw.url_s(self.photo)
        when 'q' then FlickRaw.url_q(self.photo)
        else FlickRaw.url(self.photo)
      end
    else
      nil
    end
  end

  def photo
    flickr.photos.getInfo(:photo_id => self.image_id)
  end

  def has_image?
    !image_id.nil?
  end
end
