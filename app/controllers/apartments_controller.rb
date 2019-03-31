class ApartmentsController < ApplicationController
  before_action :set_apartment, only: [:show, :edit, :update, :destroy]

  # GET /apartments
  # GET /apartments.json
  def index
    @apartments = Apartment.all
  end

  # GET /apartments/1
  # GET /apartments/1.json
  def show
    @apartments = Apartment.all
    averages = calcule_averages(@apartment)
    scores = []
    @apartments.each do |apartment|
      if apartment.id != @apartment.id
        scores << [
                  (@apartment.price - apartment.price).abs / averages[0] +
                  (@apartment.surface - apartment.surface).abs / averages[1] +
                  Math.sqrt((@apartment.latitude - apartment.latitude)**2 + (@apartment.longitude - apartment.longitude)**2) / averages[2],
                  apartment.id
        ]
      end
    end
    scores.sort!
    @similars = scores[0..3]
  end

  # GET /apartments/new
  def new
    @apartment = Apartment.new
  end

  # GET /apartments/1/edit
  def edit
  end

  # POST /apartments
  # POST /apartments.json
  def create
    @apartment = Apartment.new(apartment_params)

    respond_to do |format|
      if @apartment.save
        format.html { redirect_to @apartment, notice: 'Apartment was successfully created.' }
        format.json { render :show, status: :created, location: @apartment }
      else
        format.html { render :new }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apartments/1
  # PATCH/PUT /apartments/1.json
  def update
    respond_to do |format|
      if @apartment.update(apartment_params)
        format.html { redirect_to @apartment, notice: 'Apartment was successfully updated.' }
        format.json { render :show, status: :ok, location: @apartment }
      else
        format.html { render :edit }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apartments/1
  # DELETE /apartments/1.json
  def destroy
    @apartment.destroy
    respond_to do |format|
      format.html { redirect_to apartments_url, notice: 'Apartment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def calcule_averages(select_apartment)
    average_price = 0.0
    average_surface = 0.0
    average_distance = 0.0
    @apartments.each do |apartment|
      average_price += apartment.price
      average_surface += apartment.surface
      average_distance += Math.sqrt((select_apartment.latitude - apartment.latitude)**2 + (select_apartment.longitude - apartment.longitude)**2)
    end
    [average_price / @apartments.size, average_surface / @apartments.size, average_distance / @apartments.size]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_apartment
    @apartment = Apartment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def apartment_params
    params.require(:apartment).permit(:surface, :price, :latitude, :longitude)
  end
end
