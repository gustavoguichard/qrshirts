# == Schema Information
#
# Table name: shipping_zones
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

class ShippingZone < ActiveRecord::Base
  has_many :shipping_methods
  ## if your model requires more shipping zones create a join table and delete state.shipping_zone_id
  #has_many :state_shipping_zones
  has_many :states#, :through => :state_shipping_zones

  # USA48         = 'USA'
  # ALASKA_HAWAII = 'Alaska and Hawaii'
  # CANADA        = 'Canada'
  # USA_TERRITORY = 'USA Territory'
  # OTHER_STATE   = 'Other'
  BRASIL_TERRITORY = 'Brasil'

  LOCATIONS     = [BRASIL_TERRITORY]

  validates :name,            :presence => true,       :length => { :maximum => 255 }

  accepts_nested_attributes_for :states

end
