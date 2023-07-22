require 'rails_helper'

RSpec.describe RealEstateContent, type: :model do
  before(:each) do
    RealEstate.delete_all
    @real_estate =  RealEstate.create(realEstateName: "Estate 1", price: 100000, realEstateCountry: "Country 1", realEstateCity: "City 1")
    @content1 = RealEstateContent.create(contentName: "Content 1", description: "Content 1 description", quantity: 2, real_estate: @real_estate) 
    @content2 = RealEstateContent.new(contentName: nil, description: "Description", quantity: 2, real_estate: @real_estate) 
  end

  describe 'validations' do
    it { expect(@content2).to_not be_valid }
  end

  describe 'associations' do
    it { expect(@content1.real_estate).to eq(@real_estate) }
  end
end