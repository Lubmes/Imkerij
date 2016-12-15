class PicturesController < ApplicationController
  def visabile_toggle
    @picture = Picture.find(params[:id])
    @picture.toggle! :visable
  end

  def destroy
    @picture = Picture.find(params[:id])
    authorize @picture
    @picture.image = nil
    @picture.save
    @picture.destroy
  end

  private

  def picture_params
    permit.require(:picture).params([:product_id, :id])
  end
end
