class PicturesController < ApplicationController
  def visability_toggle
    @picture = Picture.find(params[:id])
    @picture.toggle! :visable
    @imageable = @picture.imageable
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
    permit.require(:picture).params([:id])
  end
end
