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

ActiveRecord::Schema.define(version: 2020_09_28_131452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_categories_on_title", unique: true
  end

  create_table "favorites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "listing_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_favorites_on_listing_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "listing_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "listing_id"
    t.text "image_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_listing_images_on_listing_id"
  end

  create_table "listing_tags", force: :cascade do |t|
    t.uuid "listing_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_listing_tags_on_listing_id"
    t.index ["tag_id"], name: "index_listing_tags_on_tag_id"
  end

  create_table "listing_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "listing_id"
    t.string "youtube_id"
    t.string "vimeo_id"
    t.text "video_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_listing_videos_on_listing_id"
  end

  create_table "listings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.decimal "price"
    t.text "description"
    t.integer "seller_id"
    t.datetime "release_date"
    t.boolean "preorderable"
    t.boolean "early_access"
    t.integer "hits"
    t.integer "status"
    t.integer "esrb"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["early_access"], name: "index_listings_on_early_access"
    t.index ["esrb"], name: "index_listings_on_esrb"
    t.index ["hits"], name: "index_listings_on_hits"
    t.index ["preorderable"], name: "index_listings_on_preorderable"
    t.index ["price"], name: "index_listings_on_price"
    t.index ["release_date"], name: "index_listings_on_release_date"
    t.index ["seller_id"], name: "index_listings_on_seller_id"
    t.index ["status"], name: "index_listings_on_status"
    t.index ["title"], name: "index_listings_on_title"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "seen"
    t.string "destination_path"
    t.bigint "user_id", null: false
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["seen"], name: "index_notifications_on_seen"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "listing_id", null: false
    t.integer "buyer_id", null: false
    t.decimal "coin_amount"
    t.decimal "coin_price_at_time"
    t.boolean "been_reviewed"
    t.string "escrow_address"
    t.integer "coin_type"
    t.integer "status"
    t.boolean "preordered"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyer_id"], name: "index_orders_on_buyer_id"
    t.index ["coin_amount"], name: "index_orders_on_coin_amount"
    t.index ["coin_type"], name: "index_orders_on_coin_type"
    t.index ["listing_id"], name: "index_orders_on_listing_id"
    t.index ["status"], name: "index_orders_on_status"
  end

  create_table "owned_games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "listing_id", null: false
    t.uuid "order_id", null: false
    t.uuid "supported_platform_id", null: false
    t.integer "owner_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_owned_games_on_listing_id"
    t.index ["order_id"], name: "index_owned_games_on_order_id"
    t.index ["owner_id"], name: "index_owned_games_on_owner_id"
  end

  create_table "redemptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.uuid "owned_game_id", null: false
    t.integer "platform"
    t.text "installer_data"
    t.integer "method"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owned_game_id"], name: "index_redemptions_on_owned_game_id"
  end

  create_table "reviews", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "author_id", null: false
    t.uuid "listing_id"
    t.text "content"
    t.decimal "stars"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_reviews_on_author_id"
    t.index ["listing_id"], name: "index_reviews_on_listing_id"
    t.index ["stars"], name: "index_reviews_on_stars"
  end

  create_table "sellers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "accepted_crypto", null: false, array: true
    t.integer "default_currency", null: false
    t.string "business_name", null: false
    t.integer "studio_size", null: false
    t.text "logo_data"
    t.jsonb "destination_addresses"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["accepted_crypto"], name: "index_sellers_on_accepted_crypto"
    t.index ["default_currency"], name: "index_sellers_on_default_currency"
    t.index ["studio_size"], name: "index_sellers_on_studio_size"
  end

  create_table "supported_platform_listings", force: :cascade do |t|
    t.integer "supported_platform_id", null: false
    t.uuid "listing_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_supported_platform_listings_on_listing_id"
    t.index ["supported_platform_id"], name: "index_supported_platform_listings_on_supported_platform_id"
  end

  create_table "supported_platforms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_supported_platforms_on_ancestry"
  end

  create_table "tags", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_tags_on_title", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "crypted_password", null: false
    t.string "phone_number", null: false
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_token_expires_at"
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "favorites", "listings"
  add_foreign_key "favorites", "users"
  add_foreign_key "listing_images", "listings"
  add_foreign_key "listing_tags", "listings"
  add_foreign_key "listing_tags", "tags"
  add_foreign_key "listing_videos", "listings"
  add_foreign_key "listings", "sellers"
  add_foreign_key "notifications", "users"
  add_foreign_key "orders", "listings"
  add_foreign_key "owned_games", "listings"
  add_foreign_key "owned_games", "orders"
  add_foreign_key "redemptions", "owned_games"
  add_foreign_key "reviews", "listings"
  add_foreign_key "supported_platform_listings", "listings"
  add_foreign_key "supported_platform_listings", "supported_platforms"
end
