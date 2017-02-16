class SessionsController < Devise::RegistrationsController

  def create
    super
    current_or_guest_user
  end

end
