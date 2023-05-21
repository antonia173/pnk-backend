class RealEstateTypesController < ApplicationController
  before_action :set_type, only: [:update, :destroy] 
  skip_before_action :verify_authenticity_token

  def index
    types = RealEstateType.all
    render json:types, status:200
  end

  def destroy
    @type.destroy
    render json: "Real estate deleted!"
  end

  def create
    type = RealEstateType.new(real_estate_type_params)
    if type.save
      render json:type, status: 200
    else
      render json: { error: "Creating error..."}
    end
  end

  def update
    if @type.update(real_estate_type_params)
      render json: "Real estate content updated successfuly!"
    else
      render json: { error: "Update error..."}
    end
  end

  private
  def real_estate_type_params
    params.require(:real_estate_type).permit(
      :typeName,
      :description
    )
  end

  def set_type
    @type = RealEstateType.find(params[:id])
  end
end

