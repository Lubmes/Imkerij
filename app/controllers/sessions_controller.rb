class SessionsController < Devise::SessionsController
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
      if current_user.admin?
        [:admin, :welcome]
      else
        shop_path
      end
    end
  end
end
