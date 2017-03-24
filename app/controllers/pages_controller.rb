class PagesController < ApplicationController
  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update(page_params)
      if params[:images] # voor params
        params[:images].each do |image|
          @page.pictures.create(image: image)
        end
      end
      flash[:notice] = "Pagina is bijgewerkt."
      redirect_to @page
    else
      flash.now[:alert] = "Pagina is niet bijgewerkt."
      render 'edit'
    end
  end

  def home
    @page = Page.find(1)
    render 'show'
  end

  def facilities
    @page = Page.find(2)
    render 'show'
  end

  def expo
    @page = Page.find(3)
    render 'show'
  end

  def route
    @page = Page.find(4)
    render 'show'
  end

  def extras
    @page = Page.find(5)
    render 'show'
  end

  def page_params
    params.require(:page).permit(:link, :title, :introduction, :route, :story)
  end
end
