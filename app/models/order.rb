# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  number          :string(255)
#  ip_address      :string(255)
#  email           :string(255)
#  state           :string(255)
#  user_id         :integer
#  ship_address_id :integer
#  coupon_id       :integer
#  active          :boolean          default(TRUE), not null
#  shipped         :boolean          default(FALSE), not null
#  calculated_at   :datetime
#  completed_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  credited_amount :decimal(8, 2)    default(0.0)
#  shipment_id     :integer
#  tax_rate        :decimal(8, 2)    default(0.0), not null
#

# == Class Info
#
#  The checkout process starts on the http://www.yoursite.com/shopping/cart_items page.
#
#  Clicking the "checkout button" Starts the process.  This action takes all the active
#  cart\_items in the "shopping\_cart" state and saves them as order\_items.  Each order
#  item represents one AND ONLY ONE, I repeat ONLY ONE, item.  There is no quantity field.
#  It is IMPOSSIBLE to have a quantity field and do returns correctly.  DO NOT CHANGE THIS!
#
#  At this point the Order is in an "in\_progress" state.  Immediately the user is asked to
#  enter their credentials for security reasons (unless they logged in with 20 minutes).
#  Now the user is in the checkout workflow.  The basic workflow is determined by the
#  Shopping::BaseController.next\_form(order) method.  During the checkout the user is directed
#  to the Shopping::OrdersController.index method.  The Shopping::BaseController.next\_form(order)
#  method is called and the next form to show is redirected to unless they are on the last step.
#
#  *  First it makes sure the Creditcard number passes luhn validation/date validation.
#  *  Second there is a call to the app to verify the price is correct.
#     (BTW: this could change because the user has multiple tabs open in the browser)
#  *  Then a call is made with Active Merchant to authorize the creditcard.  If all goes well the
#     transaction will go through and the card is charged when the item is shipped.
#
#  The order will now be in the 'paid' state.  Each order item will also be marked as "paid".

class Order < ActiveRecord::Base
  has_friendly_id :number, :use_slug => false

  has_many   :order_items, :dependent => :destroy
  has_one   :shipment
  has_one   :payment_notification
  has_many   :comments, :as => :commentable

  belongs_to :user
  belongs_to :coupon
  belongs_to   :ship_address, :class_name => 'Address'
  belongs_to   :bill_address, :class_name => 'Address'

  before_validation :set_email, :set_number
  after_create      :save_order_number
  before_save       :update_tax_rates



  attr_accessor :total, :sub_total, :deal_amount, :taxed_total

  #validates :number,     :presence => true
  validates :user_id,     :presence => true
  validates :email,       :presence => true,
                          :format   => { :with => CustomValidators::Emails.email_validator }

  NUMBER_SEED     = 1001001001000
  CHARACTERS_SEED = 21

  state_machine :initial => 'in_progress' do
    state 'in_progress'
    state 'complete'
    state 'paid'
    state 'canceled'

    after_transition :to => 'paid', :do => [:mark_items_paid]

    event :complete do
      transition :to => 'complete', :from => 'in_progress'
    end

    event :pay do
      transition :to => 'paid', :from => ['in_progress', 'complete']
    end
  end

  def mark_items_paid
    order_items.map(&:pay!)
  end

  # user name on the order
  #
  # @param [none]
  # @return [String] user name on the order
  def name
    self.user.name
  end

  def transaction_time
    calculated_at || Time.zone.now
  end

  # formated date of the complete_at datetime on the order
  #
  # @param [none]
  # @return [String] formated date or 'Not Finished.' if the order is not completed
  def display_completed_at(format = :us_date)
    completed_at ? I18n.localize(completed_at, :format => format) : 'Not Finished.'
  end

  # cancel the order and payment
  # => sets the order inactive and cancels the authorized payments
  #
  # @param [Invoice]
  # @return [none]
  # def cancel_unshipped_order(invoice)
  #   transaction do
  #     self.update_attributes(:active => false)
  #     invoice.cancel_authorized_payment
  #   end
  # end

  # status of the order
  #
  # @param [none]
  def status
    shipment.state
  end

  def self.finished
    where({:orders => { :state => ['complete', 'paid']}})
  end

  def add_cart_item( item, state_id = nil)
    self.save! if self.new_record?
    tax_rate_id = state_id ? item.variant.product.tax_rate(state_id) : nil
    item.quantity.times do
      oi =  OrderItem.create(
          :order        => self,
          :variant_id   => item.variant.id,
          :price        => item.variant.price,
          :tax_rate_id  => tax_rate_id)
      self.order_items.push(oi)
    end
  end

  # call after the order is completed (authorized the payment)
  # => sets the order.state to completed, sets completed_at to time.now and updates the inventory
  #
  # @param [none]
  # @return [Payment] payment object
  def order_complete!
    self.state = 'paid'
    self.completed_at = Time.zone.now
    self.shipment.prepare!
    self.save!
    update_inventory
  end

  # This method will go to every order_item and calculate the total for that item.
  #
  # if calculated at is set this order does not need to be calculated unless
  # any single item in the order has been updated since the order was calculated
  #
  # Also if any item is not ready to calculate then dont calculate
  #
  # @param [none] the param is not used right now
  # @return [none]
  def calculate_totals
    # if calculated at is nil then this order hasn't been calculated yet
    # also if any single item in the order has been updated, the order needs to be re-calculated
    if any_order_item_needs_to_be_calculated?
      calculate_each_order_items_total
      sub_total = total
      self.total = total + shipping_charges
      self.calculated_at = Time.zone.now
      save
    end
  end

  def initialize_shipment(shipping_method_id)
    unless shipment
      Shipment.create_shipments_with_items(self, shipping_method_id)
    else
      shipment.update_attributes(shipping_method_id: shipping_method_id)
    end
  end

  def all_order_items_have_a_shipping_rate?
    !order_items.any?{ |item| item.shipping_rate_id.nil? }
  end

  # This returns a hash where product_type_id is the key and an Array of prices are the values.
  #   This method is specifically used for Deal.rb
  #
  #   So for example you have a shirt that has product_type of "shirt" which is a child of product_type "clothing"
  #     "shirt" product_type_id    == 1
  #     "clothing" product_type_id == 2
  #
  #   So the order_items are a shirt ($40.00) and two other order_items that are just clothing product_type_id ($50.00 & $60.00)
  #
  #      order.number_of_a_given_product_type => {1 => [40.00], 2 => [40.00, 50.00, 60.00]}
  #
  #   Hence a deal is given out for a given product_type.
  #      buy 2 pieces of clothing get one free would work and the free item would be $40.00
  #      buy 2 shirts get one free would Not work and hence NO DEAL
  #
  # @return [Hash] This returns a hash of { product_type_id => [price, price], product_type2_id => [price, price, price]}
  def number_of_a_given_product_type
     return_hash = order_items.inject({}) do |hash, oi|
       oi.product_type_ids.each do |product_type_id|
         hash[product_type_id] ||= []
         hash[product_type_id] << oi.price
       end
       hash
     end
     return_hash
  end

  def self.include_checkout_objects
    includes([{:ship_address => :state},
              {:bill_address => :state},
              {:order_items =>
                {:variant =>
                  {:product => :images }}}])
  end

  # calculates the total price of the order
  # this method will set sub_total and total for the order even if the order is not ready for final checkout
  #
  # @param [none] the param is not used right now
  # @return [none]  Sets sub_total and total for the object
  def find_total(force = false)
    calculate_totals if self.calculated_at.nil? || order_items.any? {|item| (item.updated_at > self.calculated_at) }
    self.deal_amount = Deal.best_qualifing_deal(self)
    self.find_sub_total
    taxable_money     = (self.sub_total - deal_amount - coupon_amount) * ((100.0 + order_tax_percentage) / 100.0)
    self.total        = (self.sub_total + shipping_charges - deal_amount - coupon_amount ).round_at( 2 )
    self.taxed_total  = (taxable_money + shipping_charges).round_at( 2 )
  end

  def find_sub_total
    self.total = 0.0
    order_items.each do |item|
      self.total = self.total + item.item_total
    end
    self.sub_total = self.total
  end

  def taxed_amount
    (get_taxed_total - total).round_at( 2 )
  end

  def get_taxed_total
    taxed_total || find_total
  end

  # Turns out in order to determine the order.total_price correctly (to include coupons and deals and all the items)
  #     it is much easier to multiply the tax times to whole order's price.  This should work for most use cases.  It
  #     is rare that an order going to one location would ever need 2 tax rates
  #
  # For now this method will just look at the first item's tax rate.  In the future tax_rate_id will move to the order object
  #
  # @param none
  # @return [Float] tax rate  10.5% === 10.5
  def order_tax_percentage
    tax_rate || 0.0
  end

  # amount the coupon reduces the value of the order
  #
  # @param [none]
  # @return [Float] amount the coupon reduces the value of the order
  def coupon_amount
    coupon_id ? coupon.value(item_prices, self) : 0.0
  end

  # amount to credit based off the user store credit
  #
  # @param [none]
  # @return [Float] amount to remove from store credit
  # TODO
  def amount_to_credit
    [find_total, 0].min.to_f.round_at( 2 )
  end

  # calculates the total shipping charges for all the items in the cart
  #
  # @param [none]
  # @return [Decimal] amount of the shipping charges
  def shipping_charges(items = nil)
    return @order_shipping_charges if defined?(@order_shipping_charges)
    @order_shipping_charges = shipping_rates(items).inject(0.0) {|sum, shipping_rate|  sum + shipping_rate.rate  }
  end

  def display_shipping_charges
    items = OrderItem.order_items_in_cart(self.id)
    return 'TBD' if items.any?{|i| i.shipping_rate_id.nil? }
    shipping_charges(items)
  end

  # all the shipping rate to apply to the order
  #
  # @param [none]
  # @return [Array] array of shipping rates that will be charged, it will return the same
  #                 shipping rate more than once if it can be charged more than once
  def shipping_rates(items = nil)
    items ||= OrderItem.order_items_in_cart(self.id)
    rates = items.inject([]) do |rates, item|
      rates << item.shipping_rate if !rates.include?(item.shipping_rate)
      rates
    end
  end

  # add the variant to the order items in the order, normally called at order creation
  #
  # @param [Variant] variant to add
  # @param [Integer] quantity to add to the order
  # @param [Optional Integer] state_id (for taxes) to assign to the order_item
  # @return [none]
  def add_items(variant, quantity, state_id = nil)
    self.save! if self.new_record?
    quantity.times do
      self.order_items.push(OrderItem.create(order: self, variant_id: variant.id, price: variant.price))
    end
  end

  # remove the variant from the order items in the order
  #   THIS METHOD IS COMPLEX FOR A REASON!!!
  #   USING slice! ALLOWS THE ORDER_ITEMS TO BE DESTROYED AND UNASSOCIATED FROM THE ORDER OBJECT
  #
  # @param [Variant] variant to add
  # @param [Integer] final quantity that should be in the order
  # @return [none]
  def remove_items(variant, final_quantity)

    current_qty = 0
    items_to_remove = []
    self.order_items.each_with_index do |order_item, i|
      if order_item.variant_id == variant.id
        current_qty = current_qty + 1
        items_to_remove << i  if (current_qty - final_quantity) > 0
      end
    end
    items_to_remove.reverse.each do |i|
      self.order_items.slice!(i ,1).first.destroy # remove from order.order_items object and destroy from DB
    end
  end

  ## determines the order id from the order.number
  #
  # @param [String]  represents the order.number
  # @return [Integer] id of the order to find
  def self.id_from_number(num)
    num.to_i(CHARACTERS_SEED) - NUMBER_SEED
  end

  ## finds the Order from the orders number.  Is more optimal than the normal rails find by id
  #      because if calculates the order's id which is indexed
  #
  # @param [String]  represents the order.number
  # @return [Order]
  def self.find_by_number(num)
    find(id_from_number(num))##  now we can search by id which should be much faster
  end

  ## This method is called when the order transitions to paid
  #   it will add the number of variants pending to be sent to the customer
  #
  # @param none
  # @return [none]
  def update_inventory
    self.order_items.each { |item| item.variant.add_pending_to_customer }
  end

  # variant ids in the order.
  #
  # @param [none]
  # @return [Integer] all the variant_id's in the order
  def variant_ids
    order_items.collect{|oi| oi.variant_id }
  end

  # paginated results from the admin orders that are completed grid
  #
  # @param [Optional params]
  # @return [ Array[Order] ]
  def self.find_finished_order_grid(params = {})
    grid = Order.includes([:user]).where("orders.completed_at IS NOT NULL")
    grid = grid.where({:active => true })                     unless  params[:show_all].present?   && params[:show_all] == 'true'
    # grid = grid.where("orders.shipment_counter = ?", 0)               if params[:shipped].present? && params[:shipped] == 'true'
    # grid = grid.where("orders.shipment_counter > ?", 0)               if params[:shipped].present? && params[:shipped] == 'false'
    grid = grid.where("orders.number LIKE ?", "#{params[:number]}%")  if params[:number].present?
    grid = grid.where("orders.email LIKE ?", "#{params[:email]}%")    if params[:email].present?
    grid = grid.order("#{params[:sidx]} #{params[:sord]}")
  end

  # paginated results from the admin order fulfillment grid
  #
  # @param [Optional params]
  # @return [ Array[Order] ]
  def self.fulfillment_grid(params = {})
    grid = Order.includes([:user]).where({ :orders => {:shipped => false }} ).where("orders.completed_at IS NOT NULL")
    grid = grid.where({:active => true })                     unless  params[:show_all].present? && params[:show_all] == 'true'
    grid = grid.where("orders.number LIKE ?", "#{params[:number]}%")  if params[:number].present?
    grid = grid.where("orders.shipped = ?", true)                     if (params[:shipped].present? && params[:shipped] == 'true')
    grid = grid.where("orders.email LIKE ?", "#{params[:email]}%")    if params[:email].present?
    grid
  end

  def paypal_url(return_url, notify_url)
    values = {
      business:       ENV['PAYPAL_LOGIN'],
      cmd:            '_cart',
      currency_code:  'BRL',
      lc:             'BR',
      upload:         1,
      return:         return_url,
      invoice:        id,
      notify_url:     notify_url
    }
    i = 0
    order_items.each_with_index do |item, index|
      values.merge!({
        "amount_#{index+1}"       => item.price,
        "item_name_#{index+1}"    => "#{item.variant.product.name} - #{item.variant.name}",
        "item_number_#{index+1}"  => item.variant.id,
        "quantity_#{index+1}"     => 1
      })
      i += 1
    end
    values.merge!({
      "amount_#{i+1}"       => taxed_amount,
      "item_name_#{i+1}"    => "Taxas",
      "item_number_#{i+1}"  => id,
      "quantity_#{i+1}"     => 1
    })
    i += 1
    values.merge!({
      "amount_#{i+1}"       => shipping_charges,
      "item_name_#{i+1}"    => "Entrega",
      "item_number_#{i+1}"  => id,
      "quantity_#{i+1}"     => 1
    })
    paypal_payment_url+values.to_query
  end

  private

  def paypal_payment_url
    "https://www.#{"sandbox." unless Rails.env.production?}paypal.com/cgi-bin/webscr?"
  end

  def any_order_item_needs_to_be_calculated?
    calculated_at.nil? || (order_items.any? {|item| (item.updated_at > self.calculated_at) })
  end

  def calculate_each_order_items_total(force = false)
    self.total = 0.0
    tax_time = completed_at? ? completed_at : Time.zone.now
    order_items.each do |item|
      if (calculated_at.nil? || item.updated_at > self.calculated_at)
        # item.tax_rate = item.variant.product.tax_rate(self.ship_address.state_id, tax_time)
        item.calculate_total
        item.save
      end
      self.total = total + item.total
    end
  end

  # prices to charge of all items before taxes and coupons and shipping
  #
  # @param none
  # @return [Array] Array of prices to charge of all items before
  def item_prices
    order_items.collect{|item| item.adjusted_price }
  end

  # Called before validation.  sets the email address of the user to the order's email address
  #
  # @param none
  # @return [none]
  def set_email
    self.email = user.email if user_id
  end

  # Called before validation.  sets the order number, if the id is nil the order number is bogus
  #
  # @param none
  # @return [none]
  def set_number
    return set_order_number if self.id
    self.number = (Time.now.to_i).to_s(CHARACTERS_SEED)## fake number for friendly_id validator
  end

  # sets the order number based off constants and the order id
  #
  # @param none
  # @return [none]
  def set_order_number
    self.number = (NUMBER_SEED + id).to_s(CHARACTERS_SEED)
  end


  # Called after_create.  sets the order number
  #
  # @param none
  # @return [none]
  def save_order_number
    set_order_number
    save
  end

  # Called before save.  If the ship address changes the tax rate for all the order items needs to change appropriately
  #
  # article.title  #=> "Title"
  # article.title = "New Title"
  # article.title_changed? #=> true
  # @param none
  # @return [none]
  def update_tax_rates
    unless self.ship_address.nil?
      tax_time = completed_at? ? completed_at : Time.zone.now
      rate = TaxRate.for_region(self.ship_address.state_id).at(tax_time).active.order('start_date DESC').first
      self.tax_rate = rate ? rate.percentage : 0.0
    end
  end

end
