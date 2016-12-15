class OrdersController < ApplicationController
  require 'Mollie/API/Client'

  before_action :set_order, only: [:show, :empty, :check_out, :to_bank]
  before_action :set_user, only: [:check_out, :to_bank]

  def show
  end

  def index
    @orders = Order.all.order(created_at: :desc)
  end

  def empty
    @order.bookings.delete_all
    @order.sum_all_bookings
    @order.save
    respond_to do |format|
      format.html { redirect_to categories_path }
      format.js { render layout: false }
    end
  end

  def check_out
    @user = current_user
  end

  def to_bank
    @user = current_user
    # In volgende actie?
    mollie = Mollie::API::Client.new('test_EygcTKUUPHnS85C4c5x2GAQ74rnyWr')
    payment = mollie.payments.create({
      :amount      => 10.00,
      :description => 'My first payment',
      :redirectUrl => 'http://localhost:3000/orders/1/check_out',
      :metadata    => {
          :order_id => '1'
      }
    })
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
