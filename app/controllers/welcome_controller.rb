class WelcomeController < ApplicationController
  def index
    @banners = Banner.active
    @featured_product = Product.featured
    @products = Product.active.includes(:variants).sample(4)
    unless @featured_product
      if current_user && current_user.admin?
        redirect_to admin_merchandise_products_url
      else
        redirect_to login_url
      end
    end
  end
end
