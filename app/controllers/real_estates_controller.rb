class RealEstatesController < ApplicationController
  before_action :set_real_estate, only: [:show, :edit, :update, :destroy, :content] 
  skip_before_action :verify_authenticity_token

  def index
    real_estates = RealEstate.includes(:real_estate_type)
    response = real_estates.as_json(
      only: [:id, :realEstateName, :price, :realEstateCountry, :realEstateCity, :dateAdded, :squareSize, :yearBuilt],
      methods: :realEstateType
    )
    render json: response, status: 200
  end

  def new
    real_estate = RealEstate.new
  end

  def create
    real_estate = RealEstate.new(real_estate_params)
    real_estate.real_estate_type_id = type_params[:realEstateTypeId]
    if real_estate.save
      content_params.each do |content|
        c = RealEstateContent.new(content)
        c.real_estate_id = real_estate.id 
        if !c.save
          render json: { error: "Creating real estate content error..."}
        end
      end
      render json:real_estate, status: 200
    else
      render json: { error: "Creating error..."}
    end
  end

  def edit
  end

  def update
    type_id = type_params[:realEstateTypeId]

    if @real_estate.update(real_estate_params)
      @real_estate.update(real_estate_type_id: type_id) if RealEstateType.exists?(type_id)
      if !content_params.nil?
        content_params.each do |content|
          RealEstateContent.find_by(real_estate_id: @real_estate.id, contentName: content[:contentName]).update(content)
        end
      end
      render json: "Real estate updated successfuly!"
    else 
      render json: { error: "Creating error..."}
    end
  end

  def show
    contents = @real_estate.real_estate_contents
    type = @real_estate.real_estate_type
    if @real_estate
      response = {
        id: @real_estate.id,
        price: @real_estate.price,
        realEstateName: @real_estate.realEstateName,
        realEstateCountry: @real_estate.realEstateCountry,
        realEstateCity: @real_estate.realEstateCity,
        realEstateType: {
          realEstateTypeId: type.id,
          typeName: type.typeName,
          description: type.description
        },
        content: contents.map do |content|
          {
            contentId: content.id,
            contentName: content.contentName,
            quantity: content.quantity,
            description: content.description
          }
        end
      }
      render json: response, status: 200
    else
      render json: { error: "Real estate not found!"}
    end
  end

  def destroy
    @real_estate.destroy
    render json: "Real estate deleted!"
  end

  def content
    content = @real_estate.real_estate_contents
    render json:content, status: 200
  end
  

  private
  def real_estate_params
    params.require(:real_estate).permit(
      :price,
      :realEstateName,
      :realEstateCountry,
      :realEstateCity,
      :yearBuilt,
      :squareSize
    )
  end

  def type_params
      params.require(:realEstateType).permit(:realEstateTypeId, :typeName, :description)
  end

  def content_params
    params.require(:content).map do |content_params|
      content_params.permit(:contentName, :quantity, :description)
    end
  end

  def set_real_estate
    @real_estate = RealEstate.find(params[:id])
  end
end
