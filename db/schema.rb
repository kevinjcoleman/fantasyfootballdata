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

ActiveRecord::Schema.define(version: 20171007095325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "league_drafts", force: :cascade do |t|
    t.bigint "league_id"
    t.integer "runs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_league_drafts_on_league_id"
  end

  create_table "league_player_season_stats", force: :cascade do |t|
    t.bigint "league_id"
    t.decimal "total_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_season_id"
    t.integer "position_ranking", default: 0
    t.decimal "point_differential", default: "0.0"
    t.index ["league_id"], name: "index_league_player_season_stats_on_league_id"
    t.index ["player_season_id"], name: "index_league_player_season_stats_on_player_season_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "league_key"
    t.string "name"
    t.string "url"
    t.integer "season"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "roster_positions"
    t.hstore "stat_categories"
    t.index ["roster_positions"], name: "index_leagues_on_roster_positions", using: :gist
    t.index ["stat_categories"], name: "index_leagues_on_stat_categories", using: :gist
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
    t.integer "passing_completions", default: 0
    t.integer "passing_attempts", default: 0
    t.integer "passing_yards", default: 0
    t.integer "passing_touchdowns", default: 0
    t.integer "passing_interceptions", default: 0
    t.decimal "passing_qbr", default: "0.0"
    t.decimal "passing_rating", default: "0.0"
    t.integer "rushing_attempts", default: 0
    t.integer "rushing_yards", default: 0
    t.integer "rushing_touchdowns", default: 0
    t.integer "receptions", default: 0
    t.integer "receiving_yards", default: 0
    t.integer "receiving_touchdowns", default: 0
    t.integer "fumbles", default: 0
    t.integer "fumbles_lost", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "targets"
    t.bigint "player_id"
    t.integer "games_played", default: 0
    t.integer "position_ranking"
    t.decimal "point_positive"
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
    t.string "yahoo_key"
    t.string "image_url"
    t.string "fantasy_pro_slug"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_team_members_on_player_id"
    t.index ["team_id"], name: "index_team_members_on_team_id"
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

  create_table "weekly_stat_totals", force: :cascade do |t|
    t.bigint "league_id"
    t.bigint "weekly_stat_id"
    t.float "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_weekly_stat_totals_on_league_id"
    t.index ["weekly_stat_id"], name: "index_weekly_stat_totals_on_weekly_stat_id"
  end

  create_table "weekly_stats", force: :cascade do |t|
    t.string "matchup"
    t.text "notes"
    t.integer "week", default: 0
    t.integer "best", default: 0
    t.integer "worst", default: 0
    t.decimal "average", default: "0.0"
    t.decimal "std_dev", default: "0.0"
    t.integer "passing_completions", default: 0
    t.integer "passing_attempts", default: 0
    t.integer "passing_yards", default: 0
    t.integer "passing_touchdowns", default: 0
    t.integer "passing_interceptions", default: 0
    t.integer "rushing_attempts", default: 0
    t.integer "rushing_yards", default: 0
    t.integer "rushing_touchdowns", default: 0
    t.integer "receptions", default: 0
    t.integer "receiving_yards", default: 0
    t.integer "receiving_touchdowns", default: 0
    t.integer "fumbles", default: 0
    t.integer "fumbles_lost", default: 0
    t.integer "stat_type", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.index ["player_id"], name: "index_weekly_stats_on_player_id"
  end

  add_foreign_key "league_drafts", "leagues"
  add_foreign_key "league_player_season_stats", "leagues"
  add_foreign_key "player_seasons", "players"
  add_foreign_key "team_members", "players"
  add_foreign_key "team_members", "teams"
  add_foreign_key "teams", "leagues"
  add_foreign_key "weekly_stat_totals", "leagues"
  add_foreign_key "weekly_stat_totals", "weekly_stats"
  add_foreign_key "weekly_stats", "players"
end
