class CorrectionsController < ApplicationController
  # before_action :set_order, only: [:create, :update, :destroy]
  # before_action :set_invoice, only: [:create, :update, :destroy]
  before_action :set_correction, only: [:destroy]
  # Geen after_action update_order voor js. ? invoice ook ?

  def create
    @selection = Selection.find(params[:selection_id])
    @order = @selection.order
    @invoice = @order.active_invoice
    correction = @selection.corrections.where(invoice_id: @invoice.id).first # where invoice is current invoice
    if correction
      correction.quantity = params[:correction][:quantity]
    else
      correction = @invoice.corrections.create(correction_params)
    end
    authorize correction
    correction.save
    @order.problem!
    update_invoice
    @corrections = @selection.corrections
  end

  def destroy
    authorize @correction
    @order = @correction.selection.order
    @invoice = @order.active_invoice
    @correction.destroy
    if @invoice.corrections.any?
      update_invoice
    else
      @invoice.destroy
      @order.paid!
    end
  end

  private

  def correction_params
    params.require(:correction).permit(:quantity, :selection_id)
  end

  def set_correction
    @correction = Correction.find(params[:id])
  end

  def update_invoice
    @invoice.sum_all_corrections
    @invoice.save
  end
end
