# == Schema Information
#
# Table name: tax_rates
#
#  id         :integer          not null, primary key
#  percentage :decimal(8, 2)    default(0.0), not null
#  state_id   :integer
#  country_id :integer
#  start_date :date             not null
#  end_date   :date
#  active     :boolean          default(TRUE)
#

require 'spec_helper'

describe TaxRate do
  context "Valid TaxRate" do
    before(:each) do
      @tax_rate = build(:tax_rate)
    end
  
    it "should be valid with minimum attributes" do
      @tax_rate.should be_valid
    end
  end
end
