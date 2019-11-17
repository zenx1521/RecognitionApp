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

ActiveRecord::Schema.define(version: 20190113122321) do

  create_table "checkboxes", force: :cascade do |t|
    t.string   "description"
    t.integer  "session_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "marks", force: :cascade do |t|
    t.string   "description"
    t.integer  "point_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "points", force: :cascade do |t|
    t.float    "x"
    t.float    "y"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "attachment_id"
    t.string   "session_attachment_id"
    t.string   "integer"
  end

  create_table "session_attachments", force: :cascade do |t|
    t.integer  "session_id"
    t.string   "image"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "image_width"
    t.float    "image_height"
  end

  create_table "session_statuses", force: :cascade do |t|
    t.boolean  "finished"
    t.integer  "user_id"
    t.integer  "session_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "marked_counter"
    t.integer  "points_counter"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "token"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.boolean  "single_point"
    t.integer  "points_counter"
    t.boolean  "is_uploaded"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "surname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
