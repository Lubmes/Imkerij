class RegistrationsController < Devise::RegistrationsController
  include ShoppingOrder

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      response_to_sign_up_failure resource
    end

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
    if resource.email == "" && resource.password == nil
      redirect_to "#{root_url}orders/#{session[:order_id]}/check_out", alert: "Uw registratie formulier was leeg."
    elsif User.pluck(:email).include? resource.email
      redirect_to "#{root_url}orders/#{session[:order_id]}/check_out", alert: "Opgegeven e-mailadres bestaat al."
    end
  end

  # def response_to_sign_up_failure(resource)
  #
  #   if Rails.application.routes.recognize_path(request.referrer)[:action] == 'check_out'
  #     path = [:check_out, @order]
  #   else
  #     path = shop_path
  #   end
  #
  #   if resource.email == "" && resource.password == nil
  #     render path, alert: "Please fill in the form"
  #   elsif User.pluck(:email).include? resource.email
  #     render path, alert: "email already exists"
  #   end
  # end

end
