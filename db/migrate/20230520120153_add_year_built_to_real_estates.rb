class AddYearBuiltToRealEstates < ActiveRecord::Migration[7.0]
  def change
    add_column :real_estates, :yearBuilt, :integer
  end
end
