class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update,
                                     :destroy, :move_higher, :move_lower]
  before_action :set_category, only: [:new, :create, :edit, :update]

  include ShoppingOrder

  def show
    authorize @product
    set_shopping_order
    @selection = @order.selections.build
  end

  def new
    @product = @category.products.build
    authorize @product
  end

  def create
    @product = @category.products.build(product_params)
    authorize @product

    if @product.save
      if params[:images]
        params[:images].each do |image|
          @product.pictures.create(image: image)
        end
      end
      flash[:notice] = 'Product is toegevoegd.'
      redirect_to shop_path
    else
      flash.now[:alert] = 'Product is niet toegevoegd.'
      render 'new'
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      if params[:images] # voor params
        params[:images].each do |image|
          @product.pictures.create(image: image)
        end
      end
      flash[:notice] = "Product is bijgewerkt."
      redirect_to shop_path
    else
      flash.now[:alert] = "Product is niet bijgewerkt."
      render 'edit'
    end
  end

  def destroy
    authorize @product
    @product.destroy
    flash[:notice] = 'Product is verwijderd.'

    redirect_to shop_path
  end

  def move_higher
    @product.move_higher
    redirect_to shop_path
  end

  def move_lower
    @product.move_lower
    redirect_to shop_path
  end

  private

  def product_params
    params.require(:product).permit(policy(:product).permitted_attributes)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_category
    @category = Category.find(params[:category_id])
  end
end
