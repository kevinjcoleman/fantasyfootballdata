class UserTeamsController < ApplicationController
  def index
    current_user.fetch_teams
    @teams = current_user.teams
  end

  def show
    @team = Team.includes(:league).find(params[:id])
    LeagueLoader.new(@team.league, current_user)
  end
end
