class CreateDepartments < ActiveRecord::Migration[8.1]
  def change
    create_table :departments, id: :uuid do |t|
      t.string :department_name, null: false
      t.string :slug, null: false
      t.text :description, null: false

      t.timestamps
    end
    add_index :departments, :slug, unique: true
  end
end
