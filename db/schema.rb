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

ActiveRecord::Schema.define(version: 20170603072522) do

  create_table "qweries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "todofuken"
    t.string   "shikugun"
    t.string   "chomei"
    t.string   "type"
    t.string   "station"
    t.integer  "minute"
    t.decimal   "price",      precision: 5  , scale: 2
    t.string   "fee"
    t.string   "madori"
    t.decimal    "size",       precision: 5  , scale: 2
    t.string   "floor"
    t.integer  "comp_year"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "todofuken"
    t.string   "shikugun"
    t.string   "chomei"
    t.string   "type"
    t.string   "station"
    t.string   "address"
    t.string   "link",     limit: 1000
    t.integer  "minute"
    t.decimal   "price",      precision: 5  , scale: 2
    t.string   "fee"
    t.string   "reisiki"
    t.string   "madori"
    t.decimal    "size",       precision: 5  , scale: 2
    t.string   "floor"
    t.string  "age"
    t.string   "brand"
    t.string   "shop"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "station"
    t.string   "address"
    t.string   "link",       limit: 1000
    t.string   "minute"
    t.string   "price"
    t.string   "fee"
    t.string   "reisiki"
    t.string   "madori"
    t.string   "size"
    t.string   "floor"
    t.string   "age"
    t.string   "brand"
    t.string   "shop"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
