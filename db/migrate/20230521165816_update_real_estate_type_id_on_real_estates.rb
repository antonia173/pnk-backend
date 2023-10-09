class UpdateRealEstateTypeIdOnRealEstates < ActiveRecord::Migration[7.0]
  def change
    change_column :real_estates, :real_estate_type_id, :integer, :null => true
  end
end
