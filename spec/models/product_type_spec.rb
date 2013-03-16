# == Schema Information
#
# Table name: product_types
#
#  id        :integer          not null, primary key
#  name      :string(255)      not null
#  parent_id :integer
#  active    :boolean          default(TRUE)
#  rgt       :integer
#  lft       :integer
#

require 'spec_helper'

describe ProductType, '#admin_grid(params = {})' do
  it "should return ProductTypes " do
    product_type1 = create(:product_type)
    product_type2 = create(:product_type)
    admin_grid = ProductType.admin_grid
    info = admin_grid.all
    info.size.should == 2
    info.include?(product_type1).should be_true
    info.include?(product_type2).should be_true
  end
end
