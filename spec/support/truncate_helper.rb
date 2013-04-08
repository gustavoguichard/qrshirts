module QRShirts
  module TruncateHelper

    UNSEEDED_TABLES = [ "addresses",
                        'batches',
                        'brands',
                        'carts',
                        'comments',
                        'images',
                        'orders',
                        'order_items',
                        'payments',
                        'payment_profiles',
                        'products',
                        'product_properties',
                        'product_types',
                        'prototypes',
                        'prototype_properties',
                        'shipments',
                        'shipping_categories',
                        'shipping_methods',
                        'shipping_rates',
                        'tax_rates',
                        'transactions',
                        'transaction_ledgers',
                        "users",
                        "user_roles",
                        'variants',
                        'variant_properties'
                      ]

    def truncate_all
      tables = ActiveRecord::Base.connection.tables
      tables.each { |table| truncate table }
    end


    def trunctate_unseeded
      UNSEEDED_TABLES.each { |table| truncate table }
    end

    def truncate table
      config = ActiveRecord::Base.configurations[Rails.env]

      if config['adapter'] == 'sqlite3'
        ActiveRecord::Base.connection.execute "DELETE FROM #{table}"
      else
        ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{table}"
      end
    end
  end
end