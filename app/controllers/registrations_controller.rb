class RegistrationsController < Devise::RegistrationsController
  include ShoppingOrder

  def create
    super
    add_shopping_order_to_current_user
  end

  protected

  def after_sign_up_path_for(resource)
    @order = Order.find(session[:order_id])

    if Rails.application.routes.recognize_path(request.referrer)[:action] == 'check_out'
      [:check_out, @order]
    else
      shop_path
    end
  end
end
