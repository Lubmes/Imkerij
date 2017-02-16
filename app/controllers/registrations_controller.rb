class RegistrationsController < Devise::RegistrationsController

  def create
    super
    current_or_guest_user
  end

  protected

  def after_sign_up_path_for(resource)
    unless controller.controller_action == 'check_out'
      shop_path
    else
      check_out_order_path
    end
  end
end
