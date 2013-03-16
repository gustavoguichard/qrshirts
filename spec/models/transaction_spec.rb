# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  batch_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Transaction do
  context " Transaction" do
    before(:each) do
      @transaction = build(:transaction)
    end
    
    it "should be valid with minimum attribues" do
      @transaction.should be_valid
    end
    
  end
  
end
