class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy, :move_lower, :move_higher]

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
      redirect_to shop_path
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
      redirect_to shop_path
    else
      flash.now[:alert] = "Categorie is niet bijgewerkt."
      render 'edit'
    end
  end

  def destroy
    authorize @category
    @category.destroy
    flash[:notice] = 'Categorie is verwijderd.'
    redirect_to shop_path
  end

  def move_higher
    @category.move_higher
    redirect_to shop_path
  end

  def move_lower
    @category.move_lower
    redirect_to shop_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
