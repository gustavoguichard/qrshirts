# == Schema Information
#
# Table name: product_properties
#
#  id          :integer          not null, primary key
#  product_id  :integer          not null
#  property_id :integer          not null
#  position    :integer
#  description :string(255)      not null
#

class ProductProperty < ActiveRecord::Base
  belongs_to :product
  belongs_to :property
  
  validates :product_id, :uniqueness => {:scope => :property_id}
  validates :property_id,    :presence => true
end
