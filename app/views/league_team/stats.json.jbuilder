json.array! @team.players.each do |player|
  next unless player.weekly_stats.any?

  json.name player.name
  json.position player.position
  json.id player.id
  json.stats player.weekly_stats.order(:week).each do |stat|
    json.name player.name
    json.position player.position
    json.id player.id
    json.week  stat.week
    json.best  stat.best
    json.worst  stat.worst
    json.average   stat.average
    json.std_dev   stat.std_dev
    json.passing_completions  stat.passing_completions
    json.passing_attempts  stat.passing_attempts
    json.passing_yards  stat.passing_yards
    json.passing_touchdowns  stat.passing_touchdowns
    json.passing_interceptions  stat.passing_interceptions
    json.rushing_attempts  stat.rushing_attempts
    json.rushing_yards  stat.rushing_yards
    json.rushing_touchdowns  stat.rushing_touchdowns
    json.receptions  stat.receptions
    json.receiving_yards  stat.receiving_yards
    json.receiving_touchdowns  stat.receiving_touchdowns
    json.fumbles  stat.fumbles
    json.fumbles_lost  stat.fumbles_lost
    json.isProjection  stat.stat_type == 1
    json.total stat.week_totals.find {|t| t.league_id == @team.league_id }.try(:total) || 0
  end
end
