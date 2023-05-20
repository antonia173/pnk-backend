class CreateRealEstateType < ActiveRecord::Migration[7.0]
  def change
    create_table :real_estate_types do |t|
      t.string :typeName
      t.string :description
      t.timestamps
    end
  end
end
