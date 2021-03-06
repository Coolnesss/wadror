class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end
  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    expire_fragment('ratinglist')
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    if (not current_user.nil?)
      if @rating.save
        current_user.ratings << @rating
        @rating.user = current_user
        redirect_to user_path current_user
      else
        @beers = Beer.all
        render :new
      end
    else
        redirect_to signin_path, notice:'you should be signed in'
    end
  end

  def destroy
    expire_fragment('ratinglist')
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end
