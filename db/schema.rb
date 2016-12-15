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

ActiveRecord::Schema.define(version: 20161201113022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.string   "product_name"
    t.integer  "product_quantity"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "product_price_cents",    default: 0,     null: false
    t.string   "product_price_currency", default: "EUR", null: false
    t.index ["order_id"], name: "index_bookings_on_order_id", using: :btree
    t.index ["product_id"], name: "index_bookings_on_product_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.integer  "kind_of"
    t.string   "address_formatted_address"
    t.string   "address_street_number"
    t.string   "address_street_name"
    t.string   "address_street"
    t.string   "address_city"
    t.string   "address_zip_code"
    t.string   "address_department"
    t.string   "address_department_code"
    t.string   "address_state"
    t.string   "address_state_code"
    t.string   "address_country"
    t.string   "address_country_code"
    t.float    "address_lat"
    t.float    "address_lng"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "sender_id"
    t.index ["sender_id"], name: "index_deliveries_on_sender_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "total_cents",    default: 0,     null: false
    t.string   "total_currency", default: "EUR", null: false
    t.integer  "customer_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.boolean  "visable",            default: true
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "price_cents",                            default: 0,     null: false
    t.string   "price_currency",                         default: "EUR", null: false
    t.integer  "mail_weight"
    t.decimal  "sales_tax",      precision: 3, scale: 1
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin",                  default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "deliveries", "users", column: "sender_id"
  add_foreign_key "orders", "users", column: "customer_id"
  add_foreign_key "products", "categories"
end
