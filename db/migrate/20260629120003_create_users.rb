class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.references :department, type: :uuid, null: true, foreign_key: true
      t.string :role, null: false, default: "citizen"
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :users, :email, unique: true, where: "deleted_at IS NULL"
    add_index :users, :deleted_at
  end
end
