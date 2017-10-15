class League < ApplicationRecord
  has_many :teams, dependent: :destroy
  has_many :team_members, through: :teams, dependent: :destroy
  has_many :players, through: :team_members, dependent: :destroy
  has_many :league_stats, class_name: "LeaguePlayerSeasonStat", dependent: :destroy
  has_many :weekly_totals, class_name: "WeeklyStatTotal", dependent: :destroy
  has_one :league_draft, dependent: :destroy

  def stats_for_calculations
     stat_categories.inject({}) { |h, (k, v)| h[k] = v.to_f; h }
  end

  def update_teams
    teams.each do |team|
      player_keys = team.players.pluck(:yahoo_key)
      players = parse_results(User.first.client.draft_results(team.team_key))
      next unless players.any?
      players_keys_to_add = players.map(&:key) - player_keys
      players_to_remove = player_keys - players.map(&:key)
      Player.where(yahoo_key: players_keys_to_add).each do |player|
        next if player.yahoo_key.in?(player_keys)
        team_members.where(player_id: player.id).first_or_create.tap do |member|
          member.team_id = team.id
          member.save!
        end
      end
      team.team_members.joins(:player).where(players: {yahoo_key: players_to_remove}).update_all(team_id: nil)
    end
  end

  def parse_results(result)
    player_hash = result.dig("fantasy_content", "team", "players", "player")
    player_hash.map {|pl| YahooPlayerLoader::YahooPlayer.new(pl) } if player_hash
  end
end
