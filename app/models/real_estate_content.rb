class RealEstateContent < ApplicationRecord
  belongs_to :real_estate
  validates :contentName, presence: true
end
