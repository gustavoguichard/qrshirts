# == Schema Information
#
# Table name: shipping_methods
#
#  id               :integer          not null, primary key
#  name             :string(255)      not null
#  shipping_zone_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ShippingMethod < ActiveRecord::Base
  has_many :shipping_rates
  belongs_to :shipping_zone

  validates  :name,  :presence => true,       :length => { :maximum => 255 }
  validates  :shipping_zone_id,  :presence => true

end
