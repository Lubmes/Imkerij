module OrdersHelper
  def in_payment_process?
    controller.action_name == 'check_out' ||
		controller.action_name == 'confirm' ||
		controller.action_name == 'pay' ||
		controller.action_name == 'success'
  end
end
