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

ActiveRecord::Schema[7.1].define(version: 2025_12_02_115018) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_bookmarks_on_profile_id"
    t.index ["story_id"], name: "index_bookmarks_on_story_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "profile_id"
    t.boolean "is_custom", default: false, null: false
    t.index ["profile_id"], name: "index_characters_on_profile_id"
  end

  create_table "chats", force: :cascade do |t|
    t.string "title"
    t.bigint "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_chats_on_story_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_likes_on_profile_id"
    t.index ["story_id"], name: "index_likes_on_story_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "username"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_url"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.boolean "public"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "character_id", null: false
    t.bigint "universe_id", null: false
    t.string "status", default: "draft", null: false
    t.integer "likes_count", default: 0, null: false
    t.index ["character_id"], name: "index_stories_on_character_id"
    t.index ["profile_id"], name: "index_stories_on_profile_id"
    t.index ["universe_id"], name: "index_stories_on_universe_id"
  end

  create_table "story_characters", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_story_characters_on_character_id"
    t.index ["story_id"], name: "index_story_characters_on_story_id"
  end

  create_table "story_universes", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "universe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_story_universes_on_story_id"
    t.index ["universe_id"], name: "index_story_universes_on_universe_id"
  end

  create_table "universes", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "profile_id"
    t.boolean "is_custom", default: false, null: false
    t.index ["profile_id"], name: "index_universes_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "profiles"
  add_foreign_key "bookmarks", "stories"
  add_foreign_key "characters", "profiles"
  add_foreign_key "chats", "stories"
  add_foreign_key "likes", "profiles"
  add_foreign_key "likes", "stories"
  add_foreign_key "messages", "chats"
  add_foreign_key "profiles", "users"
  add_foreign_key "stories", "characters"
  add_foreign_key "stories", "profiles"
  add_foreign_key "stories", "universes"
  add_foreign_key "story_characters", "characters"
  add_foreign_key "story_characters", "stories"
  add_foreign_key "story_universes", "stories"
  add_foreign_key "story_universes", "universes"
  add_foreign_key "universes", "profiles"
end
