# == Schema Information
#
# Table name: payment_notifications
#
#  id             :integer          not null, primary key
#  params         :text
#  order_id       :integer
#  status         :string(255)
#  transaction_id :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  after_create :mark_order_as_purchased
  attr_accessible :order_id, :params, :status, :transaction_id

  def mark_order_as_purchased
    if status == "Completed"
      order.order_complete!
      true
    else
      false
    end
  end
end
