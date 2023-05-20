class CreateRealEstate < ActiveRecord::Migration[7.0]
  def change
    create_table :real_estates do |t|
      t.decimal :price, precision: 10, scale: 2
      t.string :realEstateName
      t.string :realEstateCountry
      t.string :realEstateCity
      t.references :real_estate_type, foreign_key: true
      t.timestamps
    end
  end
end
