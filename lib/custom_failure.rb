class CustomFailure < Devise::FailureApp
    def redirect_url
      #  new_user_session_url(:subdomain => 'secure')
      # check_out_order_url
      if request.referrer == "#{root_url}u/sign_in"
        "#{root_url}u/sign_in"
      else
        "#{root_url}orders/#{session[:order_id]}/check_out"
      end
    end

    # You need to override respond to eliminate recall
    def respond
      if http_auth?
        http_auth
      else
        redirect
      end
    end
  end
