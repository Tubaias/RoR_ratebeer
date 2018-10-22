class BeerClubsController < ApplicationController
  before_action :set_beer_club, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]

  def index
    @beer_clubs = BeerClub.all

    order = params[:order] || 'name'

    @beer_clubs = case order
                  when 'name' then @beer_clubs.sort_by{ |b| b.name.downcase }
                  when 'founded' then @beer_clubs.sort_by(&:founded)
                  when 'city' then @beer_clubs.sort_by(&:city)
                  end
  end

  def show
    if !current_user&.beer_clubs&.include? @beer_club
      @membership = Membership.new
      @membership.beer_club = @beer_club
      @membership.user = current_user
    else
      @membership = Membership.find_by(user_id: current_user.id, beer_club_id: @beer_club.id)
    end

    @comfirmed_memberships = @beer_club.memberships.select { |m| m.confirmed == true }
    @applications = @beer_club.memberships.select { |m| m.confirmed == false }

    @currentmembership = Membership.find_by(user: current_user, beer_club: @beer_club) if current_user&.beer_clubs&.include? @beer_club
  end

  def new
    @beer_club = BeerClub.new
  end

  def edit
  end

  def create
    @beer_club = BeerClub.new(beer_club_params)
    @membership = Membership.new
    @membership.beer_club = @beer_club
    @membership.user_id = current_user.id
    @membership.confirmed = true
    @membership.save

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
    if current_user&.admin
      @beer_club.destroy
      respond_to do |format|
        format.html { redirect_to beer_clubs_url, notice: 'Beer club was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to @beer_club, notice: "You must be an administrator to do this."
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
