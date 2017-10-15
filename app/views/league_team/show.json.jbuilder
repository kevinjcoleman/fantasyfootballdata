json.id @team.id
json.name @team.name
json.currentWeek CurrentSeasonInformation.current_week
json.filteredWeek CurrentSeasonInformation.current_week
json.weeks 1.upto(CurrentSeasonInformation.current_week).to_a
json.leagueName @team.league.name
