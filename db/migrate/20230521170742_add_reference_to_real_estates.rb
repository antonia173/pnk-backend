class AddReferenceToRealEstates < ActiveRecord::Migration[7.0]
  def change
    add_reference :real_estates, :real_estate_type, foreign_key: true, null: true
  end
end
