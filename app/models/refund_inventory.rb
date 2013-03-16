# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  batch_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RefundInventory < Transaction

end
