# == Schema Information
#
# Table name: payment_profiles
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  address_id     :integer
#  payment_cim_id :string(255)
#  default        :boolean
#  active         :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  last_digits    :string(255)
#  month          :string(255)
#  year           :string(255)
#  cc_type        :string(255)
#  first_name     :string(255)
#  last_name      :string(255)
#  card_name      :string(255)
#

require 'spec_helper'

describe PaymentProfile, ".create_payment_profile" do
  pending "test for create_payment_profile"
end
