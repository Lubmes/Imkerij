class CorrectionsController < ApplicationController
  # before_action :set_order, only: [:create, :update, :destroy]
  # before_action :set_invoice, only: [:create, :update, :destroy]
  before_action :set_correction, only: [:destroy]
  # Geen after_action update_order voor js. ? invoice ook ?

  def create
    @booking = Booking.find(params[:booking_id])
    @order = @booking.order
    @invoice = @order.invoices.first_or_create
    correction = @booking.corrections.first # where invoice is current invoice
    if correction
      correction.quantity = params[:correction][:quantity]
    else
      correction = @invoice.corrections.create(correction_params)
    end
    correction.save
    update_invoice
    @corrections = @booking.corrections
  end

  def destroy
    @order = @correction.booking.order
    @invoice = @order.invoices.first_or_create
    @correction.destroy
    update_invoice
  end

  private

  def correction_params
    params.require(:correction).permit(:quantity, :booking_id)
  end

  def set_correction
    @correction = Correction.find(params[:id])
  end

  def update_invoice
    @invoice.sum_all_corrections
    @invoice.save
  end
end
