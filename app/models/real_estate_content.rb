class RealEstateContent < ApplicationRecord
  belongs_to :real_estate
  validates :name, presence: true

  alias_attribute :contentName, :name

  def as_json(options = {})
    {
      id: id,
      contentName: name,
      quantity: quantity,
      description: description
    }
  end
end
