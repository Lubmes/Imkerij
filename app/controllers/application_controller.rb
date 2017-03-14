class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  # Devise
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, :unless => :devise_controller?
  include Pundit

  def store_current_location
    store_location_for(:user, request.url)
  end

  protected

  def after_sign_in_path_for(resource)
    session["user_return_to"] || shop_path
  end

  # Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
      keys: [ :first_name, :last_name, :admin ])
  end
end
