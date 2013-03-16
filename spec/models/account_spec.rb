# == Schema Information
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  account_type   :string(255)      not null
#  monthly_charge :decimal(8, 2)    default(0.0), not null
#  active         :boolean          default(TRUE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Account do
  context "Valid Account" do
    before(:each) do
      @account = build(:account)
    end
    
    it "should be valid with minimum attributes" do
      @account.should be_valid
    end
    
    Account.all.each do |acc_type|
      it "should be valid" do 
        acc_type.should be_valid
      end
    end

  end
  
end
