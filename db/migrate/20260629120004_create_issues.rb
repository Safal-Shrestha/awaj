class CreateIssues < ActiveRecord::Migration[8.1]
  def change
    create_table :issues, id: :uuid do |t|
      t.string :title, null: false
      t.text :description
      t.references :category, type: :uuid, null: false, foreign_key: true
      t.string :status, null: false, default: "reported"
      t.references :user, type: :uuid, null: true, foreign_key: true
      t.boolean :anonymous, null: false, default: false
      t.datetime :resolved_at
      t.datetime :verified_at

      t.timestamps
    end
  end
end
