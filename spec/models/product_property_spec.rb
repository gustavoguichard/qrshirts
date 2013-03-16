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

require 'spec_helper'

describe ProductProperty do
  context "Valid ProductProperty" do
    before(:each) do
      @product_property = build(:product_property)
    end
    
    it "should be valid with minimum attributes" do
      @product_property.should be_valid
    end
  end
  
end
