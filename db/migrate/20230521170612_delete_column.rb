class DeleteColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :real_estates, :real_estate_type_id
  end
end
