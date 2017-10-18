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

ActiveRecord::Schema.define(version: 20171011075337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer "delivery_id"
    t.string  "street_number"
    t.string  "street_name"
    t.string  "zip_code"
    t.string  "city"
    t.string  "country"
    t.index ["delivery_id"], name: "index_addresses_on_delivery_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "position"
  end

  create_table "corrections", force: :cascade do |t|
    t.integer "quantity"
    t.integer "selection_id"
    t.integer "invoice_id"
    t.index ["invoice_id"], name: "index_corrections_on_invoice_id", using: :btree
    t.index ["selection_id"], name: "index_corrections_on_selection_id", using: :btree
  end

  create_table "deliveries", force: :cascade do |t|
    t.integer  "kind_of"
    t.float    "address_lat"
    t.float    "address_lng"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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

  create_table "information_widgets", force: :cascade do |t|
    t.string "title"
    t.text   "information"
  end

  create_table "invoices", force: :cascade do |t|
    t.boolean  "closed",              default: false
    t.integer  "total_mail_weight",   default: 0
    t.integer  "order_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "paid_cents",          default: 0,     null: false
    t.string   "paid_currency",       default: "EUR", null: false
    t.integer  "paid_back_cents",     default: 0,     null: false
    t.string   "paid_back_currency",  default: "EUR", null: false
    t.integer  "invoice_delivery_id"
    t.index ["invoice_delivery_id"], name: "index_invoices_on_invoice_delivery_id", using: :btree
    t.index ["order_id"], name: "index_invoices_on_order_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "total_price_cents",    default: 0,     null: false
    t.string   "total_price_currency", default: "EUR", null: false
    t.integer  "customer_id"
    t.integer  "total_mail_weight",    default: 0
    t.integer  "package_delivery_id"
    t.string   "payment_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id", using: :btree
    t.index ["package_delivery_id"], name: "index_orders_on_package_delivery_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.string   "link"
    t.string   "title"
    t.text     "introduction"
    t.boolean  "route"
    t.text     "story"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "opening_times_widget_id"
    t.index ["opening_times_widget_id"], name: "index_pages_on_opening_times_widget_id", using: :btree
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
    t.integer  "position"
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
    t.integer  "position"
    t.boolean  "available",                              default: true
    t.integer  "content_weight"
    t.integer  "content_volume"
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
  end

  create_table "runs", force: :cascade do |t|
    t.integer  "delivery_id"
    t.integer  "invoice_id"
    t.string   "barcode"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "label_file_name"
    t.string   "label_content_type"
    t.integer  "label_file_size"
    t.datetime "label_updated_at"
    t.text     "label_data"
    t.index ["delivery_id"], name: "index_runs_on_delivery_id", using: :btree
    t.index ["invoice_id"], name: "index_runs_on_invoice_id", using: :btree
  end

  create_table "selections", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.string   "product_name"
    t.integer  "product_quantity"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.integer  "product_price_cents",                            default: 0,     null: false
    t.string   "product_price_currency",                         default: "EUR", null: false
    t.integer  "product_mail_weight"
    t.decimal  "product_sales_tax",      precision: 3, scale: 1
    t.index ["order_id"], name: "index_selections_on_order_id", using: :btree
    t.index ["product_id"], name: "index_selections_on_product_id", using: :btree
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

  add_foreign_key "addresses", "deliveries"
  add_foreign_key "corrections", "invoices"
  add_foreign_key "corrections", "selections"
  add_foreign_key "deliveries", "users", column: "sender_id"
  add_foreign_key "invoices", "deliveries", column: "invoice_delivery_id"
  add_foreign_key "invoices", "orders"
  add_foreign_key "orders", "deliveries", column: "package_delivery_id"
  add_foreign_key "orders", "users", column: "customer_id"
  add_foreign_key "pages", "information_widgets", column: "opening_times_widget_id"
  add_foreign_key "products", "categories"
end
