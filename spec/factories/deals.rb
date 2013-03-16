# == Schema Information
#
# Table name: deals
#
#  id              :integer          not null, primary key
#  buy_quantity    :integer          not null
#  get_percentage  :integer
#  deal_type_id    :integer          not null
#  product_type_id :integer          not null
#  get_amount      :integer
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :deal do
      buy_quantity  3
      get_percentage 50
      deal_type     { DealType.first }
      product_type  { |c| c.association(:product_type) }
      get_amount   nil
    end
end

