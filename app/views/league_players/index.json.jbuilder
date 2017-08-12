team_members = @league.team_members.includes(:team)

json.players @league_stats do |stat|
  player = stat.player_season.player
  team_member = team_members.find {|tm| tm.player_id == player.id }
  json.name player.name
  json.team team_member ? team_member.team.name : "NA"
  json.position stat.player_season.player.position
  json.total_points stat.total_points.to_f
end
