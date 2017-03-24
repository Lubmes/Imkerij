module ApplicationHelper

  # waarom deze method?
  def resource_name
    :user
  end

  # waarom deze method?
  def resource
    @resource ||= User.new
  end

  # waarom deze method?
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Helper om in de navigatie-balk custom pagina links weer te geven.
  def page_link(page_id)
    page = Page.find(page_id)
    page.link.downcase
  end

end
