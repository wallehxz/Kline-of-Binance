# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20180119024857) do

  create_table "balances", force: :cascade do |t|
    t.string   "block",      limit: 255
    t.float    "balance",    limit: 24
    t.float    "cost",       limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "bills", force: :cascade do |t|
    t.integer  "chain_id",   limit: 8
    t.integer  "stamp",      limit: 4
    t.integer  "state",      limit: 4
    t.float    "amount",     limit: 24
    t.float    "univalent",  limit: 24
    t.float    "expense",    limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "chains", force: :cascade do |t|
    t.string   "block",      limit: 255
    t.string   "currency",   limit: 255
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "day_bars", force: :cascade do |t|
    t.integer "chain_id",   limit: 8
    t.float   "o_price",    limit: 24
    t.float   "c_price",    limit: 24
    t.float   "h_price",    limit: 24
    t.float   "l_price",    limit: 24
    t.float   "volume",     limit: 24
    t.decimal "time_stamp",            precision: 15
  end

  create_table "day_indicators", force: :cascade do |t|
    t.integer "chain_id",   limit: 8
    t.integer "day_bar_id", limit: 8
    t.float   "ma5",        limit: 24
    t.float   "ma10",       limit: 24
    t.float   "macd_diff",  limit: 24
    t.float   "macd_dea",   limit: 24
    t.float   "macd_fast",  limit: 24
    t.float   "macd_slow",  limit: 24
  end

  create_table "markets", force: :cascade do |t|
    t.integer "chain_id",   limit: 8
    t.float   "o_price",    limit: 24
    t.float   "c_price",    limit: 24
    t.float   "h_price",    limit: 24
    t.float   "l_price",    limit: 24
    t.float   "volume",     limit: 24
    t.date    "diary"
    t.decimal "time_stamp",            precision: 15
  end

  add_index "markets", ["time_stamp"], name: "index_markets_on_time_stamp", using: :btree

  create_table "strategies", force: :cascade do |t|
    t.integer "chain_id", limit: 4
    t.float   "total",    limit: 24
    t.float   "bulk",     limit: 24
    t.float   "procure",  limit: 24
    t.boolean "fettle"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "role",                   limit: 4,   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
