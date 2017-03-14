module ShoppingOrder

  private

  def set_shopping_order
    @order = Order.find(session[:order_id])

  rescue ActiveRecord::RecordNotFound
    if current_user
      @order = Order.create(status: :open, customer: current_user)
    else
      @order = Order.create(status: :open)
    end
    session[:order_id] = @order.id
  end

  def add_shopping_order_to_current_user
    set_shopping_order if session[:order_id].nil?
    @order = Order.find(session[:order_id])
    @order.customer = current_user
    @order.save!
  end
end
