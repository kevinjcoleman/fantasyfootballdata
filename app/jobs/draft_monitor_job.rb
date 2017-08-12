DraftMonitorJob = Struct.new(:league_draft_id) do
  def perform
    league_draft = LeagueDraft.find_by(id: league_draft_id)
    return nil unless league_draft
    league_draft.league.teams.each do |team|
      player_keys = team.players.pluck(:yahoo_key)
      players = parse_results(User.first.client.draft_results(team.team_key))
      next unless players
      players_keys_to_add = players.map(&:key) - player_keys
      create_players(players_keys_to_add)
      sleep(2)
    end
    league_draft.runs = (league_draft.runs || 0) + 1; league_draft.save!
    Delayed::Job.enqueue DraftMonitorJob.new(league_draft_id)
  end

  def create_players(player_ids)
    players_keys_to_add.each do |key|
      player = Player.find_by(yahoo_key: key)
      team.team_members.create(player_id: player.id)
    end
  end

  def parse_results(result)
    player_hash = result.dig("fantasy_content", "team", "players")
    player_hash.each {|pl| YahooPlayerLoader::YahooPlayer.new(pl) } if player_hash
  end
end
