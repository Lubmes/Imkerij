class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update]

  def index
    @categories = Category.all.order(name: :asc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = 'Categorie is toegevoegd.'
      redirect_to categories_path
    else
      flash.now[:alert] = 'Categorie is niet toegevoegd.'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Categorie is bijgewerkt."
      redirect_to categories_path
    else
      flash.now[:alert] = "Categorie is niet bijgewerkt."
      render "edit"
    end
  end

  def destroy
    @category = Category.find(params[:id])
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
