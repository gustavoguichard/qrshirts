# == Schema Information
#
# Table name: sales
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  percent_off :decimal(8, 2)    default(0.0)
#  starts_at   :datetime
#  ends_at     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sale do
    product { |c| c.association(:product) }
    percent_off "9.99"
    starts_at "2012-08-30 17:09:52"
    ends_at "2017-08-30 17:09:52"
  end
end
