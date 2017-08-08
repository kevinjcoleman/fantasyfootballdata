class UserTeamsController < ApplicationController
  def index
    current_user.fetch_teams
    @teams = current_user.teams
  end

  def show
    @team = Team.find(params[:id])
  end
end
