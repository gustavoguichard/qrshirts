# == Schema Information
#
# Table name: shipping_categories
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

class ShippingCategory < ActiveRecord::Base
  #belongs_to :product
  has_many :products
  has_many :shipping_rates

  validates :name,            :presence => true,       :length => { :maximum => 255 }
end
