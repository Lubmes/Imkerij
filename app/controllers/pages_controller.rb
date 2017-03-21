class PagesController < ApplicationController
  def edit
  end

  def update
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
end
