class RatingsController < ApplicationController
  def index
    @ratings = Rating.includes(:beer, :user).all
    @beers = Beer.includes(:brewery, :style).all
    @recent = Rating.recent

    @top_breweries = Rails.cache.fetch("brewery top 3") { Brewery.top(3) }

    @top_beers = Rails.cache.fetch("beer top 3") { Beer.top(3) }

    @top_styles = Rails.cache.fetch("style top 3") { Style.top(3) }

    @top_users = Rails.cache.fetch("user top 3") { User.top(3) }
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in'
    elsif @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
