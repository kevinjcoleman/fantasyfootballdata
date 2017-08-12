class LeaguePlayersController < ApplicationController
  def index
    @league = League.includes(:league_stats, teams: :team_members).find(params[:league_id])
    @league_stats = @league.league_stats.includes(player_season: :player).where(player_seasons: {season: 2016}).order(total_points: :DESC)
  end

  def show
  end
end
