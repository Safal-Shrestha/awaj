class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :department, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
