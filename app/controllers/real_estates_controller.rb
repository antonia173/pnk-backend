class RealEstatesController < ApplicationController
  before_action :set_real_estate, only: [:show, :update, :destroy, :content] 
  skip_before_action :verify_authenticity_token

  def index
    real_estates = RealEstate.all
    response = real_estates.as_json
    render json: response, status: 200
  end

  def create
    begin
      creator = RealEstateCreator.new(real_estate_params)
      render json: creator.real_estate, status: 200
    rescue => e
      render json: { error: e.message }, status: 400
    end
  end

  def update
    begin
      RealEstateUpdater.new(@real_estate, real_estate_params)
      render json: "Real estate updated successfuly!", status: 200
    rescue => e
      render json: { error: e.message }, status: 400
    end
  end

  def show
    if @real_estate
      response = @real_estate.as_json(show: true)
      render json: response, status: 200
    else
      render json: { error: "Real estate not found!"}, status: 404
    end
  end

  def destroy
    if @real_estate
      @real_estate.destroy
      render json: "Real estate deleted!", status: 200
    else
      render json: "Real estate not found!", status: 404
    end
  end

  def content
    if @real_estate.real_estate_contents.present?
      contents = @real_estate.real_estate_contents.as_json
      render json: contents, status: 200
    else
      render json: "Real estate has no contents", status: 404
    end
  end
  

  private
  def real_estate_params
    params.permit(
      :realEstateName,
      :price,
      :realEstateCountry,
      :realEstateCity,
      :yearBuilt,
      :squareSize,
      realEstateType: [
        :typeName,
        :description
      ],
      content: [
        :contentName,
        :quantity,
        :description
      ]
    )
  end
  
  def set_real_estate
    @real_estate = RealEstate.find_by(id: params[:id])
  end
end
