# == Schema Information
#
# Table name: shipping_zones
#
#  id   :integer          not null, primary key
#  name :string(255)      not null
#

require 'spec_helper'

describe ShippingZone do
  context "Valid ShippingZone" do
    ShippingZone.all.each do |zone|
      it "should be valid" do 
        zone.should be_valid
      end
    end
  end
end
