# == Schema Information
#
# Table name: phones
#
#  id             :integer          not null, primary key
#  phone_type_id  :integer
#  number         :string(255)      not null
#  phoneable_type :string(255)      not null
#  phoneable_id   :integer          not null
#  primary        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Phone do
  context "Phone" do
    before(:each) do
      @phone = build(:phone)
    end
    
    it "should be valid with minimum attributes" do
      @phone.should be_valid
    end
    
  end
  
end

describe Phone, "#save_default_phone(object, params)" do
  pending "test for save_default_phone(object, params)"
end
