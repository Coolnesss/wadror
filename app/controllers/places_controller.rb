class PlacesController < ApplicationController

  def index
  end

  def show
    @last = BeermappingApi.get_bar_by_id_and_city(session[:last_search], params[:id])
  end

  def search
    #if (params[:city].empty?)
    #  redirect_to places_path, notice: "Give valid city"
    #end
    @places = BeermappingApi.places_in(params[:city])
    session[:last_search] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
