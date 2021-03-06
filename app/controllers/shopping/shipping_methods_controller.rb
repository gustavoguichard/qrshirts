class Shopping::ShippingMethodsController < Shopping::BaseController
  # GET /shopping/shipping_methods
  def index
    unless find_or_create_order.ship_address_id
      flash[:notice] = I18n.t('select_address_before_shipping_method')
      redirect_to shopping_addresses_url
    else
      session_order.find_sub_total
      ##  TODO  refactor this method... it seems a bit lengthy
      @shipping_method_ids = session_order.ship_address.shipping_method_ids

      @order_items = OrderItem.includes({:variant => {:product => :shipping_category}}).order_items_in_cart(session_order.id)
      #session_order.order_
      @order_items.each do |item|
        item.variant.product.available_shipping_rates = ShippingRate.with_these_shipping_methods(item.variant.product.shipping_category.shipping_rate_ids, @shipping_method_ids)
      end
    end
  end

  # PUT /shopping/shipping_methods/1
  def update
    if params[:shipping_category]
      items = OrderItem.includes([{:variant => :product}]).
                          where(['order_items.order_id = ? AND
                                  products.shipping_category_id = ?', session_order_id, params[:shipping_category].keys[0]])

      OrderItem.update_all("shipping_rate_id = #{params[:shipping_category].values[0]}","id IN (#{items.map{|i| i.id}.join(',')})")
      session_order.initialize_shipment params[:shipping_category].values[0]
      redirect_to(shopping_orders_url, :notice => I18n.t('shipping_method_updated'))
    else
      redirect_to( shopping_shipping_methods_url, :notice => I18n.t('all_shipping_methods_must_be_selected'))
    end
  end

end
