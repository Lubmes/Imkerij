class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  # Devise
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, :unless => :devise_controller?
  include Pundit

  # als een gebruiker is ingelogd: return current_user;
  # als gebruiker niet is ingelogd: return guest_user.
  def current_or_guest_user
    if current_user
      # als je komt vanuit een guest sessie..
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        # ...zet guest data over naar current_user.
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


  # als de gebruiker wel is ingelogd: vind onverwerkte ('open') order;
  # anders: maak een nieuwe aan.
  # als gebruiker niet is ingelogd: maak nieuwe order aan op de guest.
  def current_order
    if user_signed_in?
      # if Order.where(customer_id: current_user.id, status: :confirmed)
        # current_order = Order.where(customer_id: current_user.id, status: :confirmed).first
      # else
        current_order = Order.where(customer_id: current_user.id, status: :open).first_or_create(status: :open)
        # current_order.save
      # end
    else
      current_order = Order.where(customer_id: guest_user.id).first_or_create(status: :open)
      # current_order.save
    end
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
