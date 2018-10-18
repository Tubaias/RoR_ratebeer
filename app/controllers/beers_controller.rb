class BeersController < ApplicationController
  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  before_action :set_breweries_and_styles_for_template, only: [:new, :edit, :create]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]

  def index
    @beers = Beer.all

    order = params[:order] || 'name'

    @beers = case order
      when 'name' then @beers.sort_by{ |b| b.name }
      when 'brewery' then @beers.sort_by{ |b| b.brewery.name }
      when 'style' then @beers.sort_by{ |b| b.style.name }
    end
  end

  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  def list
  end

  def new
    @beer = Beer.new
  end

  def edit
  end

  def create
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
        format.json { render :show, status: :created, location: @beer }
      else
        format.html { render :new }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user&.admin
      @beer.destroy
      respond_to do |format|
        format.html { redirect_to beers_url, notice: 'Beer was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to @beer, notice: "You must be an administrator to do this."
    end
  end

  private

  def set_beer
    @beer = Beer.find(params[:id])
  end

  def set_breweries_and_styles_for_template
    @breweries = Brewery.all
    @styles = Style.all
  end

  def beer_params
    params.require(:beer).permit(:name, :style_id, :brewery_id)
  end
end
