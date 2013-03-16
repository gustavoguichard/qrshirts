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

require 'spec_helper'

describe ShippingMethod do
  context "Valid ShippingMethod" do
    before(:each) do
      @shipping_method = build(:shipping_method)
    end
    
    it "should be valid with minimum attributes" do
      @shipping_method.should be_valid
    end
  end
  
end
