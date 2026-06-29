class CreateVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :votes, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :issue, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
    add_index :votes, [:user_id, :issue_id], unique: true
  end
end
