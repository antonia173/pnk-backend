class CreateRealEstateDetail < ActiveRecord::Migration[7.0]
  def change
    create_table :real_estate_details do |t|
      t.references :real_estate, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
  end
end
