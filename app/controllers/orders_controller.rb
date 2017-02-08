class OrdersController < ApplicationController
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
    # gebruiker selecteerd een adres uit zijn bestand.
    @delivery = @user.deliveries.first unless @user.nil?
  end

  def to_bank
    # verzendadres moet aan order gekoppeld zijn! order = pakket.
    @delivery = @user.deliveries.first unless @user.nil?
    @order.package_delivery = @delivery
    if @order.package_delivery.nil?
      flash.now[:alert] = 'U moet een verzendadres opgeven.'
      render 'check_out'
    end
    if @user == nil
      flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
      render 'check_out'
    end
    @order.save
  end

  def success
    if @user == nil
      flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
      render 'check_out'
    end
    @order.status = 'paid'
    @order.save
    @invoice = @order.invoices.create(paid: @order.total_price,
                                      total_mail_weight: @order.total_mail_weight,
                                      invoice_delivery: @order.package_delivery)
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
