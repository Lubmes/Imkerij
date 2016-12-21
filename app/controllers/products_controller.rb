class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_category, only: [:new, :create, :edit, :update]

  def show
    authorize @product
    @booking = current_order.bookings.build
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
      redirect_to categories_path
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
      if params[:images]
        params[:images].each do |image|
          @product.pictures.create(image: image)
        end
      end
      flash[:notice] = "Product is bijgewerkt."
      redirect_to categories_path
    else
      flash.now[:alert] = "Product is niet bijgewerkt."
      render 'edit'
    end
  end

  def destroy
    authorize @product
    @product.destroy
    flash[:notice] = 'Product is verwijderd.'

    redirect_to categories_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :sales_tax, :mail_weight,
      :category_id)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_category
    @category = Category.find(params[:category_id])
  end
end