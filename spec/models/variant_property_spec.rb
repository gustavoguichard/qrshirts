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

require 'spec_helper'

describe VariantProperty do
  context "Valid VariantProperty" do
    before(:each) do
      @variant_property = build(:variant_property)
    end

    it "should be valid with minimum attributes" do
      @variant_property.should be_valid
    end

    it 'should not be valid' do
      variant = create(:variant)
        property      = create(:property)
        create(:variant_property, :variant => variant, :property => property)
        variant_property = build(:variant_property, :variant => variant, :property => property)
        variant_property.should_not be_valid
    end
  end

  #
  context " VariantProperty instance methods" do
    it 'should return property_name' do
      property      = create(:property, :display_name => 'name')
      variant_property = create(:variant_property, :property => property)
      variant_property.property_name.should == 'name'
    end
  end
end
