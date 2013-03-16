# == Schema Information
#
# Table name: coupons
#
#  id            :integer          not null, primary key
#  type          :string(255)      not null
#  code          :string(255)      not null
#  amount        :decimal(8, 2)    default(0.0)
#  minimum_value :decimal(8, 2)
#  percent       :integer          default(0)
#  description   :text             not null
#  combine       :boolean          default(FALSE)
#  starts_at     :datetime
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CouponFirstPurchasePercent < CouponPercent
  include CouponFirstPurchase
end
