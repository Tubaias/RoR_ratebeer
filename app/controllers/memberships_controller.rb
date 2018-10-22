class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  def index
    @memberships = Membership.all
  end

  def show
  end

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  def edit
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.confirmed = false
    @membership.user = current_user

    if @membership.save
      redirect_to beer_club_path(@membership.beer_club_id), notice: "#{@membership.user.username} welcome to the club!"
    else
      @beer_clubs = BeerClub.all
      render :new
    end
  end

  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_confirmed
    membership = Membership.find(params[:id])

    return if !current_user.beer_clubs.include? membership.beer_club

    membership.update_attribute :confirmed, !membership.confirmed

    new_status = membership.confirmed? ? "confirmed" : "unconfirmed"

    redirect_to membership.beer_club, notice: "membership confirmation status changed to #{new_status}"
  end

  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: "Membership in #{@membership.beer_club.name} ended." }
      format.json { head :no_content }
    end
  end

  private

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def membership_params
    params.require(:membership).permit(:beer_club_id, :user_id, :confirmed)
  end
end
