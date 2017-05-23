class SelectionsController < ApplicationController
  include ShoppingOrder
  # Om AJAX op de boekingen te laten werken.
  skip_before_action :verify_authenticity_token, :only => [:create]
  # before_action :set_order, only: [:create, :update, :destroy]
  before_action :set_shopping_order, only: [:create, :update, :destroy]
  before_action :set_selection, only: [:update, :destroy]
  # (Geen after_action update_order. Werkt niet met AJAX.)

  def create
    product = Product.find(params[:selection][:product_id])
    selection = @order.selections.find_by(product_id: product.id)
    unless selection
      selection = Selection.new(selection_params)
      selection.product_name  = product.name
      selection.product_price = product.price
      selection.product_sales_tax = product.sales_tax
      selection.product_mail_weight = product.mail_weight
      @order.selections << selection
    else
      selection.product_quantity = params[:selection][:product_quantity]
    end
    authorize selection
    selection.save
    update_order

    respond_to do |format|
      format.html { redirect_to shop_url }
      format.js
    end
  end

  def update
    # authorize @selection
    @selection.product_quantity = params[:selection][:product_quantity]
    @selection.save
    update_order

    respond_to do |format|
      format.html { redirect_to shop_url }
      format.js
    end
  end

  def destroy
    @selection.destroy
    @selections = @order.selections
    update_order

    respond_to do |format|
      format.html { redirect_to shop_url }
      format.js
    end
  end

  private

  def selection_params
    params.require(:selection).permit(:product_quantity, :product_id)
  end

  # def set_shopping_order
  #   set_shopping_order
  #   # @order = current_order
  # end

  def set_selection
    @selection = Selection.find(params[:id])
  end

  def update_order
    @order.sum_all_selections
    @order.save
  end
end
