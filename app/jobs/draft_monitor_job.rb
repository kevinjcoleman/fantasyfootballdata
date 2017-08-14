DraftMonitorJob = Struct.new(:league_draft_id) do
  def perform
    league_draft = LeagueDraft.find_by(id: league_draft_id)
    return nil unless league_draft
    if league_draft.updated_at > Time.now - 10.seconds
      Delayed::Job.enqueue DraftMonitorJob.new(league_draft_id)
      return nil
    end
    league_draft.league.teams.each do |team|
      player_keys = team.players.pluck(:yahoo_key)
      puts player_keys
      players = parse_results(User.first.client.draft_results(team.team_key))
      puts players
      next unless players.any?
      players_keys_to_add = players.map(&:key) - player_keys
      create_players(players_keys_to_add, team)
    end
    league_draft.runs = (league_draft.runs || 0) + 1; league_draft.save!
    Delayed::Job.enqueue DraftMonitorJob.new(league_draft_id)
  end

  def create_players(player_ids, team)
    player_ids.each do |key|
      player = Player.find_by(yahoo_key: key)
      team.team_members.create(player_id: player.id) if player
    end
  end

  def parse_results(result)
    player_hash = result.dig("fantasy_content", "team", "players", "player")
    player_hash.map {|pl| YahooPlayerLoader::YahooPlayer.new(pl) } if player_hash
  end
end
