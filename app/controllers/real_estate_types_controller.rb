class RealEstateTypesController < ApplicationController

  def index
    types = RealEstateType.all
    render json:types, status:200
  end
end