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

# Several classes inhertit this class.  This class describes the transaction type in the accounting system
#
class Transaction < ActiveRecord::Base
  belongs_to :batch

  has_many :transaction_ledgers

  validates :batch_id,    :presence => true
  validates :type,        :presence => true

  def new_transaction_ledgers( transactor, credit_transaction_account_id, debit_transaction_account_id, amount, at)
    transaction_ledgers.push( transactor.new_credit(credit_transaction_account_id, amount, at) )
    transaction_ledgers.push( transactor.new_debit(debit_transaction_account_id, amount, at) )
  end
end
