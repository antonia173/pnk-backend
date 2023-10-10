class RealEstate < ApplicationRecord
  has_many :real_estate_contents, dependent: :destroy
  belongs_to :real_estate_type, optional: true
  validates :price, presence: true
  validates :name, presence: true
  validates :city, presence: true
  validates :country, presence: true

  alias_attribute :realEstateName, :name
  alias_attribute :realEstateCountry, :country
  alias_attribute :realEstateCity, :city
  alias_attribute :yearBuilt, :year_built
  alias_attribute :squareSize, :square_size

  def type_name
    real_estate_type.name if real_estate_type.present?
  end

  def date_added
    created_at.strftime("%Y-%m-%d")
  end

  def as_json(options = {})
    json = {
      id: id,
      realEstateName: name,
      price: price, 
      realEstateCountry: country,
      realEstateCity: city,
      dateAdded: date_added,
      yearBuilt: year_built,
      squareSize: square_size,
      realEstateType: type_name
    }

    if options[:show] 
      json[:content] = real_estate_contents.as_json
      json[:realEstateType] = real_estate_type.as_json 
    end

    json
  end
  
end
