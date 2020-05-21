# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_20_072424) do

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "icon_url"
    t.string "forum_url"
    t.string "apidocs_url"
    t.string "download_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "script_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "script_id"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_script_categories_on_category_id"
    t.index ["script_id"], name: "index_script_categories_on_script_id"
  end

  create_table "script_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "script_id"
    t.bigint "skill_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["script_id"], name: "index_script_skills_on_script_id"
    t.index ["skill_id"], name: "index_script_skills_on_skill_id"
  end

  create_table "scripts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 1000
    t.string "author"
    t.string "price"
    t.string "url", limit: 2500
    t.string "icon_url"
    t.text "description_text"
    t.text "description_html", size: :medium
    t.string "download_url"
    t.integer "user_count"
    t.integer "download_count"
    t.boolean "official"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_scripts_on_client_id"
  end

  create_table "skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "wiki_url"
    t.string "icon_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "members_only", default: false, null: false
  end

  add_foreign_key "script_categories", "categories"
  add_foreign_key "script_categories", "scripts"
  add_foreign_key "script_skills", "scripts"
  add_foreign_key "script_skills", "skills"
  add_foreign_key "scripts", "clients"
end
