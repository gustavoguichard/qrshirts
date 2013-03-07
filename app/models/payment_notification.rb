class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  after_create :mark_order_as_purchased
  attr_accessible :order_id, :params, :status, :transaction_id

  def mark_order_as_purchased
    if status == "Completed"
      order.order_complete!
    end
  end
end
