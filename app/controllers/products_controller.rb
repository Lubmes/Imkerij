class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update]
  before_action :set_category, only: [:new, :create, :edit, :update]

  def new
    @product = @category.products.build
  end

  def create
    @product = @category.products.build(product_params)

    if @product.save
      flash[:notice] = 'Product is toegevoegd.'
      redirect_to categories_path
    else
      flash.now[:alert] = 'Product is niet toegevoegd.'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Product is bijgewerkt."
      redirect_to categories_path
    else
      flash.now[:alert] = "Product is niet bijgewerkt."
      render "edit"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:notice] = 'Product is verwijderd.'

    redirect_to categories_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :category_id)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_category
    @category = Category.find(params[:category_id])
  end
end
