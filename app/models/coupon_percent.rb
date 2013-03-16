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

class CouponPercent < Coupon

  validates :percent, :presence => true

  private

  def coupon_amount(item_prices)
    ( value_of_items_to_apply(item_prices) * ( percent.to_f / 100.0 ) ).round_at(2)
  end

end
