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

  def response_to_sign_up_failure(resource)
    if Rails.application.routes.recognize_path(request.referrer)[:action] == 'check_out'
      path = [:check_out, @order]
    else
      path = shop_path
    end

    if resource.email == "" && resource.password == nil
      render path, alert: "Please fill in the form"
    elsif User.pluck(:email).include? resource.email
      render path, alert: "email already exists"
    end
  end

end
