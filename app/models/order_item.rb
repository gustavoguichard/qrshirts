# == Schema Information
#
# Table name: order_items
#
#  id               :integer(4)      not null, primary key
#  price            :decimal(8, 2)
#  total            :decimal(8, 2)
#  order_id         :integer(4)      not null
#  variant_id       :integer(4)      not null
#  state            :string(255)     not null
#  tax_rate_id      :integer(4)
#  shipping_rate_id :integer(4)
#  shipment_id      :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :shipping_rate
  belongs_to :variant
  belongs_to :tax_rate
  belongs_to :shipment

  has_many   :return_items

  validates :variant_id,  :presence => true
  validates :order_id,    :presence => true

  state_machine :initial => 'unpaid' do
    event :pay do
      transition :to => 'paid', :from => ['unpaid']
    end
    event :return do
      transition :to => 'returned', :from => ['paid']
    end
    #after_transition :to => 'complete', :do => [:update_inventory]
  end

  def product_type
    variant.product.product_type
  end

  def product_type_ids
    product_type.self_and_ancestors.map(&:id)
  end

 # if the order item has been shipped it will return true
 #
 # @param [none]
 # @return [Boolean]
  def shipped?
    shipment_id?
  end

  # shipping method for the order item
  #
  # @param [none]
  # @return [ShippingMethod]
  def shipping_method
    shipping_rate.shipping_method
  end

  # shipping method id for the order item (use to reduce SQL calls)
  #   refer to ShippingMethod ID constants to determine what shipping method is called
  #
  # @param [none]
  # @return [Integer] ShippingMethod id
  def shipping_method_id
    shipping_rate.shipping_method_id
  end

  def ship_category_id
    variant.product.shipping_category_id
  end

  def shipping_rate_options(total_charge)
    ShippingRate.joins(:shipping_method).where(['shipping_rates.shipping_category_id = ?
                        AND shipping_methods.shipping_zone_id = ?
                        AND shipping_rates.minimum_charge <= ?', ship_category_id, order.ship_address.state.shipping_zone_id, total_charge]).all
  end

  # called in checkout process. will give you the 'quantity', 'sum of all the prices' and 'sum of all the totals'
  #  it is better to do the math in SQL than ruby
  #
  # @param [Integer]  order.id
  # @return [OrderItem] Object has addional attributes of [sum_price, sum_total, shipping_category_id, and quantity]
  def self.order_items_in_cart(order_id)
    find(:all, :joins => {:variant => :product },
               :conditions => { :order_items => { :order_id => order_id}},
               :select => "order_items.id, order_items.order_id, order_items.shipping_rate_id, order_items.state, order_items.tax_rate_id, order_items.price, order_items.total, order_items.variant_id,
                           products.shipping_category_id,
                                          count(*) as quantity,
                                          products.shipping_category_id as shipping_category_id,
                                          SUM(order_items.price) as sum_price,
                                          SUM(order_items.total) as sum_total",
               :group => "order_items.id,
                          products.shipping_category_id,
                          order_items.order_id,
                          order_items.shipping_rate_id,
                          order_items.state,
                          order_items.tax_rate_id,
                          order_items.price,
                          order_items.total, order_items.variant_id")
  end

  # this is the price after coupons and anything before calculating the price + tax
  #  in the future coupons and discounts could change this value
  #
  # @param [none]
  # @return [Float] this is the price that the tax will be applied to.

  def adjusted_price(coupon = nil)
    ## coupon credit is calculated at the order level but because taxes we need to apply it now
    coupon_credit = coupon ? coupon.value([sale_price(order.transaction_time)], order) : 0.0

    self.price - coupon_credit
  end

  def sale_price(at)
    sale = sale_at(at)
    sale ? ( (1.0 - sale.percent_off) * self.price ).round_at(2) : self.price
  end

  def sale_at(at = Time.zone.now)
    Sale.for(variant.product_id, at)
  end

  # this is the price after coupons and taxes
  #   * this return total if has not been calculated, otherwise calculates the total.
  #
  # @param [none]
  # @return [Float] this is the total of the item after taxes and coupons...
  def item_total(coupon = nil)
    # shipping charges are calculated in order.rb

    self.total ||= calculate_total(coupon)
  end

  # this is the price after coupons, deals and sales
  #   * this method does not save it just sets the value of total.
  #   * Thus allowing you to save the whole order with one opperation
  #
  # @param [none]
  # @return [Float] this is the total of the item after coupons/deals/sales...
  def calculate_total(coupon = nil)
    # shipping charges are calculated in order.rb

    self.total = (adjusted_price(coupon)).round_at(2)
  end

  # the tax charge on an item
  #
  # @param [none]
  # @return [Float] tax charge on the item.
  def tax_charge
    tax_percentage = tax_rate.try(:tax_percentage) ? tax_rate.tax_percentage : 0.0
    adjusted_price * tax_percentage / 100.0
  end

  # the VAT charge on an item
  #
  # @param [none]
  # @return [Float] tax charge on the item.
  def amount_of_charge_is_vat
    vat_percentage = tax_rate.try(:vat_percentage) ? tax_rate.vat_percentage : 0.0
    (adjusted_price * (vat_percentage / (100.0 + vat_percentage))).round_at(2)
  end

  # the amount of an item if there were zero VAT
  #
  # @param [none]
  # @return [Float] tax charge on the item.
  def amount_of_charge_without_vat
    vat_percentage = tax_rate.try(:vat_percentage) ? tax_rate.vat_percentage : 0.0
    (100.0 * adjusted_price / (100.0 + vat_percentage)).round_at(2)
  end
end
