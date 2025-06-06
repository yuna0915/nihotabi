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

ActiveRecord::Schema.define(version: 2025_05_28_100631) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_favorites_on_post_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "inquiries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.boolean "is_checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_inquiries_on_user_id"
  end

  create_table "inquiry_replies", force: :cascade do |t|
    t.integer "inquiry_id", null: false
    t.integer "admin_id", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_inquiry_replies_on_admin_id"
    t.index ["inquiry_id"], name: "index_inquiry_replies_on_inquiry_id"
  end

  create_table "location_genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_active", default: true, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "notified_user_id", null: false
    t.integer "post_id"
    t.integer "comment_id"
    t.string "action", null: false
    t.boolean "is_checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notifiable_type"
    t.integer "notifiable_id"
    t.index ["comment_id"], name: "index_notifications_on_comment_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["notified_user_id"], name: "index_notifications_on_notified_user_id"
    t.index ["post_id"], name: "index_notifications_on_post_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "location_genre_id", null: false
    t.integer "prefecture_id", null: false
    t.integer "visited_month_id", null: false
    t.integer "visited_time_zone_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.string "location_name", null: false
    t.string "address", default: "", null: false
    t.float "latitude", default: 0.0, null: false
    t.float "longitude", default: 0.0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "view_count", default: 0, null: false
    t.index ["location_genre_id"], name: "index_posts_on_location_genre_id"
    t.index ["prefecture_id"], name: "index_posts_on_prefecture_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
    t.index ["visited_month_id"], name: "index_posts_on_visited_month_id"
    t.index ["visited_time_zone_id"], name: "index_posts_on_visited_time_zone_id"
  end

  create_table "prefectures", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_active", default: true, null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "terms", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.string "nickname", null: false
    t.string "phone_number", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "introduction"
    t.integer "prefecture_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["prefecture_id"], name: "index_users_on_prefecture_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visited_months", force: :cascade do |t|
    t.string "number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_active", default: true, null: false
  end

  create_table "visited_time_zones", force: :cascade do |t|
    t.string "hour", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_active", default: true, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "posts", on_delete: :cascade
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "posts", on_delete: :cascade
  add_foreign_key "favorites", "users"
  add_foreign_key "inquiries", "users"
  add_foreign_key "inquiry_replies", "admins"
  add_foreign_key "inquiry_replies", "inquiries"
  add_foreign_key "notifications", "comments"
  add_foreign_key "notifications", "posts"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "notified_user_id"
  add_foreign_key "posts", "location_genres"
  add_foreign_key "posts", "prefectures"
  add_foreign_key "posts", "users"
  add_foreign_key "posts", "visited_months"
  add_foreign_key "posts", "visited_time_zones"
  add_foreign_key "users", "prefectures"
end
