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

ActiveRecord::Schema.define(version: 2020_04_29_090141) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "bowtype"
    t.string "gender"
    t.integer "age"
    t.integer "gmb_hc"
    t.integer "mb_hc"
    t.integer "bowman_hc"
    t.integer "first_hc"
    t.integer "second_hc"
    t.integer "third_hc"
    t.integer "a_hc"
    t.integer "b_hc"
    t.integer "c_hc"
    t.integer "d_hc"
    t.integer "e_hc"
    t.integer "f_hc"
    t.integer "g_hc"
    t.integer "h_hc"
  end

  create_table "handicaps", force: :cascade do |t|
    t.integer "round_id", null: false
    t.integer "value"
    t.integer "score"
    t.string "round_name"
    t.index ["round_id", "value"], name: "index_handicaps_on_round_id_and_value"
    t.index ["round_id"], name: "index_handicaps_on_round_id"
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.string "name"
    t.boolean "indoor", default: false
    t.string "organisation"
    t.integer "max_hits"
    t.integer "max_score"
    t.integer "arrows_per_end"
    t.string "distance_1"
    t.integer "face_1"
    t.integer "ends_1"
    t.string "distance_2"
    t.integer "face_2"
    t.integer "ends_2"
    t.string "distance_3"
    t.integer "face_3"
    t.integer "ends_3"
    t.string "distance_4"
    t.integer "face_4"
    t.integer "ends_4"
    t.text "notes"
    t.string "gmb_achievable", default: "0"
    t.string "mb_achievable", default: "0"
    t.string "bowman_achievable", default: "0"
    t.string "first_achievable", default: "0"
    t.string "second_achievable", default: "0"
    t.string "third_achievable", default: "0"
    t.string "bowstyle"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "score"
    t.integer "hits"
    t.integer "golds"
    t.integer "xs"
    t.integer "round_id", null: false
    t.integer "category_id", null: false
    t.integer "user_id", null: false
    t.string "name"
    t.text "comment"
    t.date "date"
    t.string "location"
    t.integer "handicap"
    t.string "classification"
    t.boolean "home"
    t.boolean "club_record"
    t.boolean "county_record"
    t.boolean "uk_record"
    t.boolean "validated"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_scores_on_category_id"
    t.index ["round_id"], name: "index_scores_on_round_id"
    t.index ["user_id", "created_at"], name: "index_scores_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.integer "current_outdoor_hc"
    t.integer "current_indoor_hc"
    t.string "current_outdoor_class"
    t.string "current_indoor_class"
    t.integer "age_group"
    t.string "gender"
    t.string "default_bowtype"
    t.integer "category"
    t.datetime "date_of_birth"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "handicaps", "rounds"
  add_foreign_key "microposts", "users"
  add_foreign_key "scores", "categories"
  add_foreign_key "scores", "rounds"
  add_foreign_key "scores", "users"
end
