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

FactoryGirl.define do
  factory :accounting_adjustment do
      adjustable_id 1
      adjustable_type "MyString"
      notes "MyString"
      amount "9.99"
    end
end
