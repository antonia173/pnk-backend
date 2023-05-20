class CreateRealEstateContent < ActiveRecord::Migration[7.0]
  def change
    create_table :real_estate_contents do |t|
      t.string :contentName
      t.string :description
      t.integer :quantity
      t.references :real_estate, null: false, foreign_key: { on_delete: :cascade }
    end
  end
end
