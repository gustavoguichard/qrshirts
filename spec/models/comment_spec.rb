# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  note             :text
#  commentable_type :string(255)
#  commentable_id   :integer
#  created_by       :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Comment do
  context "Comment" do
    before(:each) do
      User.any_instance.stubs(:start_store_credits).returns(true)  ## simply speed up tests, no reason to have store_credit object
      @comment = build(:comment)
    end
    
    it "should be valid with minimum attributes" do
      @comment.should be_valid
    end
    
  end
  
end
