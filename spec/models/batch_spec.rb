# == Schema Information
#
# Table name: batches
#
#  id             :integer          not null, primary key
#  batchable_type :string(255)
#  batchable_id   :integer
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Batch do
  context " Batch" do
    before(:each) do
      @batch = build(:batch)
    end
    
    it "should be valid with minimum attribues" do
      @batch.should be_valid
    end
    
  end
  
end

