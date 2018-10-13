class RatingsController < ApplicationController
    def index
        @ratings = Rating.all
        @recent = Rating.recent
        @topbreweries = Brewery.top(3)
        @topbeers = Beer.top(3)
        @topstyles = Style.top(3)
        @topusers = User.top(3)
    end

    def new
        @rating = Rating.new
        @beers = Beer.all
    end

    def create
        @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

        if current_user.nil?
            redirect_to signin_path, notice: 'you should be signed in'
            return
        end

        @rating.user = current_user

        if @rating.save
          redirect_to user_path current_user
        else
          @beers = Beer.all
          render :new
        end
    end

    def destroy
        rating = Rating.find params[:id]
        rating.delete if current_user == rating.user
        redirect_to user_path(current_user)
    end
end
