class OrdersController < ApplicationController
  # require 'Mollie/API/Client'

  before_action :set_order, only: [:show, :empty, :check_out, :to_bank, :success]
  before_action :set_user, only: [:check_out, :to_bank, :success]

  def show
  end

  def index
    @orders = Order.all.order(created_at: :desc)
    @guest_orders = @orders.joins(:customer).where(users: {first_name: 'guest'})

    @all_orders = @orders.joins(:customer).where.not(users: {first_name: 'guest'})
    @open_orders = @all_orders.open
    @problem_orders = @all_orders.problem
    @paid_orders = @all_orders.paid
    @sent_orders = @all_orders.sent
  end

  def empty
    @order.bookings.delete_all
    @order.sum_all_bookings
    @order.save
    respond_to do |format|
      format.html { redirect_to shop_path }
      format.js { render layout: false }
    end
  end

  def check_out
    @delivery = @user.deliveries.first unless @user.nil?
  end

  def to_bank
    @delivery = @user.deliveries.first unless @user.nil?
    if @user == nil
      flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
      render 'check_out'
    end
    # In volgende actie?
    # mollie = Mollie::API::Client.new('test_EygcTKUUPHnS85C4c5x2GAQ74rnyWr')
    # payment = mollie.payments.create({
    #   :amount      => 10.00,
    #   :description => 'My first payment',
    #   :redirectUrl => 'http://localhost:3000/orders/1/check_out',
    #   :metadata    => {
    #       :order_id => '1'
    #   }
    # })
  end

  def success
    @delivery = @user.deliveries.first unless @user.nil?
    if @user == nil
      flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
      render 'check_out'
    end
    @order.status = 'paid'
    @order.save
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
