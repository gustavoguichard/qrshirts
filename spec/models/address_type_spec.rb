# == Schema Information
#
# Table name: address_types
#
#  id          :integer          not null, primary key
#  name        :string(64)       not null
#  description :string(255)
#

require 'spec_helper'

describe AddressType do
  describe "Valid Seed data" do
    
    AddressType.all.each do |add_type|
      it "should be valid" do 
        add_type.should be_valid
      end
    end
    
  end
end
