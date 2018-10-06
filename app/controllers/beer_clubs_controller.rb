class BeerClubsController < ApplicationController
  before_action :set_beer_club, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]

  def index
    @beer_clubs = BeerClub.all
  end

  def show
    @membership = Membership.new
    @membership.beer_club = @beer_club

    @currentmembership = Membership.find_by(user: current_user, beer_club: @beer_club) if current_user.beer_clubs.include? @beer_club
  end

  def new
    @beer_club = BeerClub.new
  end

  def edit
  end

  def create
    @beer_club = BeerClub.new(beer_club_params)

    respond_to do |format|
      if @beer_club.save
        format.html { redirect_to @beer_club, notice: 'Beer club was successfully created.' }
        format.json { render :show, status: :created, location: @beer_club }
      else
        format.html { render :new }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @beer_club.update(beer_club_params)
        format.html { redirect_to @beer_club, notice: 'Beer club was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer_club }
      else
        format.html { render :edit }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @beer_club.destroy
    respond_to do |format|
      format.html { redirect_to beer_clubs_url, notice: 'Beer club was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_beer_club
    @beer_club = BeerClub.find(params[:id])
  end

  def beer_club_params
    params.require(:beer_club).permit(:name, :founded, :city)
  end
end
