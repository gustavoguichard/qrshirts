# == Schema Information
#
# Table name: sales
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  percent_off :decimal(8, 2)    default(0.0)
#  starts_at   :datetime
#  ends_at     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Sale, '#for(product_id, at)' do
  it "should return sale" do
    product = FactoryGirl.create(:product)
    new_sale = FactoryGirl.create(:sale,
                                  :product_id   => product.id,
                                  :starts_at    => (Time.zone.now - 1.days),
                                  :ends_at      => (Time.zone.now + 1.days),
                                  :percent_off  => 0.20
                                  )

    sale = Sale.for(product.id, Time.zone.now)
    sale.id.should == new_sale.id

    sale = Sale.for(product.id, (Time.zone.now - 2.days))
    sale.should be_nil

    sale = Sale.for(product.id, (Time.zone.now + 2.days))
    sale.should be_nil
  end
end
