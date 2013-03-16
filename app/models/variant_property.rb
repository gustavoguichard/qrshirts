# == Schema Information
#
# Table name: variant_properties
#
#  id          :integer          not null, primary key
#  variant_id  :integer          not null
#  property_id :integer          not null
#  description :string(255)      not null
#  primary     :boolean          default(FALSE)
#

class VariantProperty < ActiveRecord::Base

  belongs_to :variant
  belongs_to :property

  validates :variant_id, :uniqueness => {:scope => :property_id}
  validates :property_id,  :presence => true
  validates :description,  :presence => true,       :length => { :maximum => 255 }


  # name of the property
  #
  # @param [none]
  # @return [String]
  def property_name
    property.display_name
  end
end
