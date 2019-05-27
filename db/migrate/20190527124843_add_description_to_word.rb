class AddDescriptionToWord < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :description, :text
    add_column :words, :check, :integer
  end
end
