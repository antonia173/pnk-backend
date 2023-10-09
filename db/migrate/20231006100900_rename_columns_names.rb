class RenameColumnsNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :real_estates, :realEstateName, :name
    rename_column :real_estates, :realEstateCountry, :country
    rename_column :real_estates, :realEstateCity, :city
    rename_column :real_estates, :yearBuilt, :year_built
    rename_column :real_estates, :squareSize, :square_size
    remove_column :real_estates, :dateAdded

    rename_column :real_estate_types, :typeName, :name

    rename_column :real_estate_contents, :contentName, :name
  end
end
