json.array! @team.players.each do |player|
  stats = player.weekly_stats.first
  next unless stats

  json.name player.name
  json.position player.position
  json.week  stats.week
  json.best  stats.best
  json.worst  stats.worst
  json.average   stats.average
  json.std_dev   stats.std_dev
  json.passing_completions  stats.passing_completions
  json.passing_attempts  stats.passing_attempts
  json.passing_yards  stats.passing_yards
  json.passing_touchdowns  stats.passing_touchdowns
  json.passing_interceptions  stats.passing_interceptions
  json.rushing_attempts  stats.rushing_attempts
  json.rushing_yards  stats.rushing_yards
  json.rushing_touchdowns  stats.rushing_touchdowns
  json.receptions  stats.receptions
  json.receiving_yards  stats.receiving_yards
  json.receiving_touchdowns  stats.receiving_touchdowns
  json.fumbles  stats.fumbles
  json.fumbles_lost  stats.fumbles_lost
  json.isProjection  stats.stat_type == 1
end
