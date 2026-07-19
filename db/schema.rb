# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_29_120006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "department_id", null: false
    t.text "description", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_categories_on_department_id"
  end

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "department_name", null: false
    t.text "description", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_departments_on_slug", unique: true
  end

  create_table "issue_updates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "from_state"
    t.uuid "issue_id", null: false
    t.string "to_state", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["issue_id"], name: "index_issue_updates_on_issue_id"
    t.index ["user_id"], name: "index_issue_updates_on_user_id"
  end

  create_table "issues", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "anonymous", default: false, null: false
    t.uuid "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "resolved_at"
    t.string "status", default: "reported", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.datetime "verified_at"
    t.integer "votes_count", default: 0, null: false
    t.index ["category_id"], name: "index_issues_on_category_id"
    t.index ["status"], name: "index_issues_on_status"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.uuid "department_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "role", default: "user", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "issue_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["issue_id"], name: "index_votes_on_issue_id"
    t.index ["user_id", "issue_id"], name: "index_votes_on_user_id_and_issue_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "categories", "departments"
  add_foreign_key "issue_updates", "issues"
  add_foreign_key "issue_updates", "users"
  add_foreign_key "issues", "categories"
  add_foreign_key "issues", "users"
  add_foreign_key "users", "departments"
  add_foreign_key "votes", "issues"
  add_foreign_key "votes", "users"
end
