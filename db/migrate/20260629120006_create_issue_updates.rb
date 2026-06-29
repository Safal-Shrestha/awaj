class CreateIssueUpdates < ActiveRecord::Migration[8.1]
  def change
    create_table :issue_updates, id: :uuid do |t|
      t.references :issue, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: true, foreign_key: true
      t.string :from_state
      t.string :to_state, null: false
      t.text :description, null: true

      t.timestamps
    end
  end
end
