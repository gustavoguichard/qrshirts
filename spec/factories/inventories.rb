# == Schema Information
#
# Table name: inventories
#
#  id                        :integer          not null, primary key
#  count_on_hand             :integer          default(0)
#  count_pending_to_customer :integer          default(0)
#

FactoryGirl.define do
  factory :inventory do
    count_on_hand             10000
    count_pending_to_customer 1000
  end
end
