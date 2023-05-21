class AddReferenceToRealEstates < ActiveRecord::Migration[7.0]
  def change
    add_reference :real_estates, :real_estate_type, foreign_key: { on_delete: :nullify }
  end
end
