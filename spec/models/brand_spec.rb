# == Schema Information
#
# Table name: brands
#
#  id       :integer          not null, primary key
#  name     :string(255)
#  image_id :string(255)
#  featured :boolean          default(FALSE), not null
#

require 'spec_helper'

describe Brand do
  context " Brand" do
    before(:each) do
      @brand = build(:brand)
    end
    
    it "should be valid with minimum attribues" do
      @brand.should be_valid
    end
    
  end
  
end
