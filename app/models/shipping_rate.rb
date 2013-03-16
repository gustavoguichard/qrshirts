# == Schema Information
#
# Table name: shipping_rates
#
#  id                   :integer          not null, primary key
#  shipping_method_id   :integer          not null
#  rate                 :decimal(8, 2)    default(0.0), not null
#  shipping_category_id :integer          not null
#  minimum_charge       :decimal(8, 2)    default(0.0), not null
#  position             :integer
#  active               :boolean          default(TRUE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class ShippingRate < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :shipping_method

  belongs_to  :shipping_category
  has_many    :products

  validates  :rate,                   :presence => true, :numericality => true

  validates  :shipping_method_id,     :presence => true
  validates  :shipping_category_id,   :presence => true

  scope :with_these_shipping_methods, lambda { |shipping_rate_ids, shipping_method_ids|
          where("shipping_rates.id IN (?)", shipping_rate_ids).
          where("shipping_rates.shipping_method_id IN (?)", shipping_method_ids)
        }

  MONTHLY_BILLING_RATE_ID = 1

  # the shipping method name, shipping zone and sub_name
  # ex. '3 to 5 day UPS, International, Individual - 5.50'
  #
  # @param [none]
  # @return [ String ]
  def name
    [shipping_method.name, shipping_method.shipping_zone.name, sub_name].join(', ')
  end

  # the shipping rate type and $$$ rate  separated by ' - '
  # ex. 'Individual - 5.50'
  #
  # @param [none]
  # @return [ String ]
  def sub_name
    "(#{rate})"
  end

  # the shipping method name, and $$$ rate
  # ex. '3 to 5 day UPS - $5.50'
  #
  # @param [none]
  # @return [ String ]
  def name_rate_min
    [name_with_rate, "(min order => #{minimum_charge})" ].join(' ')
  end

  # the shipping method name, and $$$ rate
  # ex. '3 to 5 day UPS - $5.50'
  #
  # @param [none]
  # @return [ String ]
  def name_with_rate
    [shipping_method.name, charge_amount].compact.join(' - ')
  end

  private
    def charge_amount
      number_to_currency(rate)
    end
end
