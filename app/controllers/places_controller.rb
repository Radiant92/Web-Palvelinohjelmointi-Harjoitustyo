class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.search_one(params[:id])
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.nil?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
