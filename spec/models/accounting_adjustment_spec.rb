# == Schema Information
#
# Table name: accounting_adjustments
#
#  id              :integer          not null, primary key
#  adjustable_id   :integer          not null
#  adjustable_type :string(255)      not null
#  notes           :string(255)
#  amount          :decimal(8, 2)    not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe AccountingAdjustment do
  context '#adjust_stock(inventory, qty_to_add, return_amount)' do
    it "should update count on hand" do
      inventory = create(:inventory, :count_on_hand => 30000)
      AccountingAdjustment.adjust_stock(inventory, 1000, 12.00)
      inventory.reload
      inventory.count_on_hand.should == 31000
    end
  end
end

