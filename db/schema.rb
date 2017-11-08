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

ActiveRecord::Schema.define(version: 20171105111549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "short_links", force: :cascade do |t|
    t.string   "url"
    t.string   "shortcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shortcode"], name: "index_short_links_on_shortcode", unique: true, using: :btree
  end

  create_table "stats", force: :cascade do |t|
    t.datetime "start_date"
    t.integer  "redirect_count", default: 0
    t.datetime "last_seen_date"
    t.integer  "short_link_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["short_link_id"], name: "index_stats_on_short_link_id", using: :btree
  end

  add_foreign_key "stats", "short_links"
end
