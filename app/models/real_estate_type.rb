class RealEstateType < ApplicationRecord
  has_many :real_estates
  validates :typeName, presence: true
  validates_uniqueness_of :typeName
end
