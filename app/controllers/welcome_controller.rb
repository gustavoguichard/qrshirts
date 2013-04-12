class WelcomeController < ApplicationController
  def index
    @banners = Banner.active
    @featured_product = Product.featured
    @best_selling_products = Product.active.sample(4).includes(:variants)
    unless @featured_product
      if current_user && current_user.admin?
        redirect_to admin_merchandise_products_url
      else
        redirect_to login_url
      end
    end
  end
end
