class Admin::Inventory::AdjustmentsController < Admin::BaseController

  def edit
    @variant = Variant.includes(:product).find(params[:id])
  end

  def update
    @variant = Variant.find(params[:id])
    ###  the reason will effect accounting
    #    if the item is refunded by the supplier the accounting will be reflected
    if params[:refund].to_f > 0.0
      AccountingAdjustment.adjust_stock(@variant.inventory, params[:variant][:qty_to_add].to_i, params[:refund].to_f)
      flash[:notice] = "Successfully updated the inventory."
      redirect_to admin_inventory_overviews_url
    elsif @variant.update_attributes(params[:variant])
      flash[:notice] = "Successfully updated the inventory."
      redirect_to admin_inventory_overviews_url
    else
      render :action => 'edit', :id => params[:id]
    end
  end

  private

end

