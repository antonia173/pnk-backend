class AddDateAddedToRealEstates < ActiveRecord::Migration[7.0]
  def change
    add_column :real_estates, :dateAdded, :date, default: Date.current
  end
end
