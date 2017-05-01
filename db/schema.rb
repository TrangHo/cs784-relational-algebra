# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170501002759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
  end

  create_table "problems", force: :cascade do |t|
    t.text     "description"
    t.boolean  "approved",      default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "name"
    t.string   "slug"
    t.string   "solution"
    t.jsonb    "solution_json", default: {}
    t.index ["approved"], name: "index_problems_on_approved", using: :btree
    t.index ["slug"], name: "index_problems_on_slug", using: :btree
  end

  create_table "relation_attributes", force: :cascade do |t|
    t.integer  "relation_id"
    t.string   "name"
    t.string   "attr_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["relation_id"], name: "index_relation_attributes_on_relation_id", using: :btree
  end

  create_table "relations", force: :cascade do |t|
    t.integer  "problem_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id", "name"], name: "index_relations_on_problem_id_and_name", using: :btree
  end

  create_table "test_cases", force: :cascade do |t|
    t.integer  "problem_id"
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.jsonb    "dataset",    default: {}
  end

end
