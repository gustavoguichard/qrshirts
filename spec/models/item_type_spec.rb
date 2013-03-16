# == Schema Information
#
# Table name: item_types
#
#  id   :integer          not null, primary key
#  name :string(255)
#

require 'spec_helper'

describe ItemType do
  describe "Seed data" do
    ItemType.all.each do |item_type|
      it "should be valid" do 
        item_type.should be_valid
      end
    end
  end
end
