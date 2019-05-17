class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.text :key
      t.boolean :zumi
      t.date :zumi_dt

      t.timestamps
    end
  end
end
