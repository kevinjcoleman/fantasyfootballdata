class LeagueTeamController < ApplicationController
  before_action :find_team
  def show
  end

  def stats
    @players = @team.players
  end

  private
  def find_team
    @team = Team.find(params[:id])
  end
end
