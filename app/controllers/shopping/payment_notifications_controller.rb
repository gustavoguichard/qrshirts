class Shopping::PaymentNotificationsController < Shopping::BaseController
  protect_from_forgery except: [:create]

  def create
    if PaymentNotification.create!(params: params, order_id: params[:invoice], status: params[:payment_status], transaction_id: params[:txn_id])
      @order = Order.find params[:invoice]
      # destroy_current_cart!
    end
    render nothing: true
  end
end
