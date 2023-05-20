class RealEstateDetail < ApplicationRecord
  belongs_to :real_estate
  has_one :real_estate_type, through: :real_estate
  has_many :real_estate_contents, through: :real_estate
end
