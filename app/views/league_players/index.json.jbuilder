json.players @league_stats do |stat|
  json.name stat.player_season.player.name
  json.position stat.player_season.player.position
  json.total_points stat.total_points.to_f
end
