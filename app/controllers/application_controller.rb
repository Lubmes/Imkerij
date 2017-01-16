class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  # Devise
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :store_current_location, :unless => :devise_controller?


  # als een gebruiker is ingelogd: current_user; anders: guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # herlaad guest_user om caching problemen te voorkomen voor destroy
        guest_user(with_retry = false).reload.try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # vind een guest_user object geassocieerd met de huidige sessie,
  # creeër er een wanneer nodig
  def guest_user(with_retry = true)
    # Cache de waarde de eerste keer dat deze is verkregen.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # als session[:guest_user_id] niet valide is
     session[:guest_user_id] = nil
     guest_user if with_retry
  end


  # als gebruiker niet is ingelogd: maak order aan op de guest.
  # als de gebruiker wel herkend wordt: vind onverwerkte order;
  # anders: maak een nieuwe aan.
  def current_order
    if user_signed_in?
      current_order = Order.where(customer_id: current_user.id, status: :open).first_or_initialize(status: :open)
    else
      current_order = Order.where(customer_id: guest_user.id).first_or_initialize(status: :open)
    end
  end

  protected

  def after_sign_in_path_for(resource)
    session["user_return_to"] || shop_path
  end

  # Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
      keys: [ :first_name, :last_name,
              :address_street_name, :address_street_number, :address_zip_code, :address_city, :address_country,
              :admin
            ])
  end

  private

  def store_current_location
    store_location_for(:user, request.url)
  end

  # # Eén keer aangeroepen wanneer de gebruiker inlogd, hier de code die nodig is
  # # voor de overgang van guest_user naar current_user.
  def logging_in
    # Voorbeeld:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
    current_order.user_id = current_user.id
    current_order.save!
  end

  def create_guest_user
    u = User.create(:first_name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end
end
