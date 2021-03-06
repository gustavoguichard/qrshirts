FactoryGirl.define do
  factory :variant do
    sku           '345-98765-0987'
    product       { |c| c.association(:product) }
    brand       { |c| c.association(:brand) }
    price  11.00
    cost          8.00
    deleted_at    nil
    master        false
    inventory   { |c| c.association(:inventory) }
    #count_on_hand             10000
    #count_pending_to_customer 1000
  end


  factory :five_dollar_variant, :class => Variant do |f| # :parent => :variant,
    price  5.00
    sku           '345-98765-0980'
    product       { |c| c.association(:product) }
    brand       { |c| c.association(:brand) }
    cost          3.00
    deleted_at    nil
    master        false
    inventory     { |c| c.association(:inventory) }
    #count_on_hand             10000
    #count_pending_to_customer 1000
  end
end
