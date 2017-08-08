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

ActiveRecord::Schema.define(version: 20170808061125) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leagues", force: :cascade do |t|
    t.string "league_key"
    t.string "name"
    t.string "url"
    t.integer "season"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nfl_teams", force: :cascade do |t|
    t.string "name"
    t.string "espn_slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "espn_short_slug"
  end

  create_table "player_seasons", force: :cascade do |t|
    t.integer "season"
    t.integer "passing_completions"
    t.integer "passing_attempts"
    t.integer "passing_yards"
    t.integer "passing_touchdowns"
    t.integer "passing_interceptions"
    t.decimal "passing_qbr"
    t.decimal "passing_rating"
    t.integer "rushing_attempts"
    t.integer "rushing_yards"
    t.integer "rushing_touchdowns"
    t.integer "receptions"
    t.integer "receiving_yards"
    t.integer "receiving_touchdowns"
    t.integer "fumbles"
    t.integer "fumbles_lost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "targets"
    t.bigint "player_id"
    t.index ["player_id"], name: "index_player_seasons_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "position"
    t.integer "age"
    t.string "espn_id"
    t.string "height"
    t.integer "weight"
    t.integer "experience"
    t.string "college"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.string "espn_slug"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "league_id"
    t.string "team_key"
    t.string "name"
    t.string "logo_url"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.index ["league_id"], name: "index_teams_on_league_id"
    t.index ["owner_id"], name: "index_teams_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "refresh_token"
    t.string "token"
    t.string "name"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "player_seasons", "players"
  add_foreign_key "teams", "leagues"
end
