class AddCategoryIdToMicropost < ActiveRecord::Migration[5.1]
  def change
    add_reference :microposts, :category, foreign_key: true
  end
end
