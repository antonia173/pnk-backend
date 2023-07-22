require 'rails_helper'

RSpec.describe RealEstate, type: :model do
  before(:each) do
    RealEstate.delete_all
    RealEstateType.delete_all
    @type =  RealEstateType.create!(typeName: "Type A", description: "Description Type A")
    @real_estate =  RealEstate.create(realEstateName: "Estate 1", price: 100000, realEstateCountry: "Country 1", realEstateCity: "City 1", real_estate_type: @type)
    @content = RealEstateContent.create(contentName: "Content 1", description: "Content 1 description", quantity: 2, real_estate: @real_estate) 

    @real_estate2 =  RealEstate.create(realEstateName: nil, price: 100000,realEstateCountry: "Country 1", realEstateCity: "City 1")
    @real_estate3 =  RealEstate.create(realEstateName: nil, price: nil, realEstateCountry: "Country 1", realEstateCity: "City 1")
    @real_estate4 =  RealEstate.create(realEstateName: "Estate", price: 100000, realEstateCountry: nil, realEstateCity: "City 1")
    @real_estate5 =  RealEstate.create(realEstateName: "Estate 1", price: 100000, realEstateCountry: "Country", realEstateCity: nil)

  end

  describe 'validations' do
    it { expect(@real_estate2).to_not be_valid }
    it { expect(@real_estate3).to_not be_valid }
    it { expect(@real_estate4).to_not be_valid }
    it { expect(@real_estate5).to_not be_valid }
  end

  describe 'associations' do
    it { expect(@real_estate.real_estate_contents).to eq([@content]) }
    it { expect(@real_estate.real_estate_type).to eq(@type) }
  end
end