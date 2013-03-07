class PaymentNotification < ActiveRecord::Base
  attr_accessible :order_id, :params, :status, :transaction_id
end
