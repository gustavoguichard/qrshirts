# coding: utf-8
# == Schema Information
#
# Table name: images
#
#  id                 :integer(4)      not null, primary key
#  t.string           :image_id        default: "", :null => false
#  t.integer          :product_id      null: false
#  position           :integer(4)
#  caption            :string(255)
#  updated_at         :datetime
#  created_at         :datetime
#

# require 'paperclip'

class Image < ActiveRecord::Base
  # belongs_to :imageable, :polymorphic => true
  belongs_to :product

  # has_attached_file :photo, PAPERCLIP_STORAGE_OPTS ##  this constant is in /config/environments/*.rb

#image_tag @product.photo.url(:small)
  # validates_attachment_presence :photo
  # validates_attachment_size     :photo, :less_than => 5.megabytes
  # validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']

  # validates :imageable_type,  :presence => true
  # validates :imageable_id,    :presence => true
  # validate :validate_photo
  validates :position, :image_id, presence: true

  # attr_accessor :photo_link

  default_scope :order => 'position'

  def photo(size = :square)
    case size
      when :square    then FlickRaw.url_s(photo_info)
      when :medium    then FlickRaw.url_q(photo_info)
      when :small     then FlickRaw.url_n(photo_info)
      when :large     then FlickRaw.url_z(photo_info)
      else FlickRaw.url(photo_info)
    end
  rescue
    nil
  end

private

  def photo_info
    flickr.photos.getInfo(photo_id: self.image_id) rescue nil
  end

  # save the w,h of the original image (from which others can be calculated)
  # after_post_process :find_dimensions
  # MAIN_LOGO = 'logo'

  # def photo_from_link=(val)
  #   if !val.blank?
  #     self.photo_link = val
  #     self.photo = open(val)
  #   end
  # end

  # def photo_from_link
  #   self.photo_link || ''
  # end
  # this will be called after an image is uploaded.
  # => it will set the width and height of the image.
  # => It will not save the object
  #
  # @param [none]
  # @return [none] but does set the height and width
  # def find_dimensions
  #   temporary = photo.queued_for_write[:original]
  #   filename = temporary.path unless temporary.nil?
  #   filename = photo.path if filename.blank?
  #   geometry = Paperclip::Geometry.from_file(filename)
  #   self.image_width  = geometry.width
  #   self.image_height = geometry.height
  # end

  # if there are errors from the plugin, then add a more meaningful message
  # def validate_photo
  #   unless photo.errors.empty?
  #     # uncomment this to get rid of the less-than-useful interrim messages
  #     # errors.clear
  #     errors.add :attachment, "Paperclip returned errors for file '#{photo_file_name}' - check ImageMagick installation or image source file."
  #     false
  #   end
  # end
end
