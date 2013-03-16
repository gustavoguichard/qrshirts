# == Schema Information
#
# Table name: transaction_ledgers
#
#  id                     :integer          not null, primary key
#  accountable_type       :string(255)
#  accountable_id         :integer
#  transaction_id         :integer
#  transaction_account_id :integer
#  tax_amount             :decimal(8, 2)    default(0.0)
#  debit                  :decimal(8, 2)    not null
#  credit                 :decimal(8, 2)    not null
#  period                 :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe TransactionLedger do
  context " TransactionLedger" do
    before(:each) do
      @transaction_ledger = build(:transaction_ledger)
    end
    
    it "should be valid with minimum attribues" do
      @transaction_ledger.should be_valid
    end
    
  end
  
end
