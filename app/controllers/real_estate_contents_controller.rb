class RealEstateContentsController < ApplicationController
  before_action :set_real_estate_content, only: [:show, :edit, :update, :destroy] 
  skip_before_action :verify_authenticity_token

  def new
    content = RealEstateContent.new
  end

  def create
    content = RealEstateContent.new(real_estate_content_params)
    if content.save
      render json:content, status: 200
    else
      render json: { error: "Creating error..."}
    end
  end

  def edit
  end

  def update
    if @content.update(real_estate_content_params)
      render json: "Real estate content updated successfuly!"
    else
      render json: { error: "Update error..."}
    end
  end

  def destroy
    @content.destroy
    redirect_to root_path
  end

  private
  def real_estate_content_params
    params.require(:real_estate_content).permit(:contentName, :description, :quantity, :real_estate_id)
  end

  def set_real_estate_content
    @content = RealEstateContent.find(params[:id])
  end
end
