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
    real_estate_params = details_params.slice(:price, :realEstateName, :realEstateCountry, :realEstateCity, :yearBuilt, :squareSize)
    type_id = details_params[:realEstateType][:realEstateTypeId]
    contents = details_params[:content]

    puts real_estate_params
    real_estate = RealEstate.new(real_estate_params)
    if real_estate.save
      real_estate.update(real_estate_type_id: type_id) if RealEstateType.exists?(type_id)
      contents.each do |content|
        RealEstateContent.create(content.slice(:contentName, :quantity, :description))
      end
      render json:real_estate, status: 200
    else
      render json: { error: "Creating error..."}
    end
  end

  def edit
  end

  def update
    real_estate_params = details_params.slice(:price, :realEstateName, :realEstateCountry, :realEstateCity, :yearBuilt, :squareSize)
    type_id = details_params[:realEstateType][:realEstateTypeId]
    contents = details_params[:content]

    if @real_estate.update(real_estate_params)
      @real_estate.update(real_estate_type_id: type_id) if RealEstateType.exists?(type_id)

      contents.each do |content|
        RealEstateContent.find(content[:contentId]).update(content.slice(:contentName, :quantity, :description))
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
  def details_params
    params.permit(
      :price,
      :realEstateName,
      :realEstateCountry,
      :realEstateCity,
      :yearBuilt,
      :squareSize,
      realEstateType: [:realEstateTypeId],
      content: [:contentId, :contentName, :quantity, :description]
    )
  end

  def set_real_estate
    @real_estate = RealEstate.find(params[:id])
  end
end
