class RealEstateType < ApplicationRecord
  has_many :real_estates
  validates :name, presence: true
  validates_uniqueness_of :name

  alias_attribute :typeName, :name

  def as_json(options = {})
    {
      id: id,
      typeName: name,
      description: description
    }
  end
end
