class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update]

  def index
    skip_authorization
    @categories = Category.all.order(id: :asc)
    # Voor het inzien van wat al geselecteerd is.
    @order = current_order
    # Voor het aanslaan van een nieuwe booking.
    @booking = current_order.bookings.build
  end

  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    authorize @category

    if @category.save
      if params[:images]
        params[:images].each do |image|
          @category.pictures.create(image: image)
        end
      end
      flash[:notice] = 'Categorie is toegevoegd.'
      redirect_to categories_path
    else
      flash.now[:alert] = 'Categorie is niet toegevoegd.'
      render 'new'
    end
  end

  def edit
    authorize @category
  end

  def update
    authorize @category
    if @category.update(category_params)
      if params[:images]
        params[:images].each do |image|
          @category.pictures.create(image: image)
        end
      end
      flash[:notice] = "Categorie is bijgewerkt."
      redirect_to categories_path
    else
      flash.now[:alert] = "Categorie is niet bijgewerkt."
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    authorize @category
    @category.destroy
    flash[:notice] = 'Categorie is verwijderd.'
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
