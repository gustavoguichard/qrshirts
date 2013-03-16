# == Schema Information
#
# Table name: transaction_accounts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe TransactionAccount do
  context "Valid TransactionAccount" do
    TransactionAccount.all.each do |acc|
      it "should be valid" do 
        acc.should be_valid
      end
    end
  end#end of context
end
