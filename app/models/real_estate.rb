class RealEstate < ApplicationRecord
  has_many :real_estate_contents, dependent: :destroy
  belongs_to :real_estate_type
  validates :price, presence: true
  validates :realEstateName, presence: true
  validates :realEstateCity, presence: true
  validates :realEstateCountry, presence: true

  def realEstateType
    real_estate_type.typeName if real_estate_type.present?
  end
end
