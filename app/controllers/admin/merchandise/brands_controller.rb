# encoding: UTF-8
class Admin::Merchandise::BrandsController < Admin::BaseController
  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find(params[:id])
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(params[:brand])
    if @brand.save
      flash[:notice] = "Estampa criada com sucesso."
      redirect_to admin_merchandise_brand_url(@brand)
    else
      render :action => 'new'
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      flash[:notice] = "Estampa atualizada com sucesso."
      redirect_to admin_merchandise_brands_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @brand = Brand.find(params[:id])

    if @brand.products.empty?
      @brand.destroy
    else
      flash[:alert] = "Essa estampa está associada com uma camisa, você não pode deletá-la."
    end

    redirect_to admin_merchandise_brands_url
  end

end
