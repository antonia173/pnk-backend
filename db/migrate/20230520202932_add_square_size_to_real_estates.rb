class AddSquareSizeToRealEstates < ActiveRecord::Migration[7.0]
  def change
    add_column :real_estates, :squareSize, :integer
  end
end
