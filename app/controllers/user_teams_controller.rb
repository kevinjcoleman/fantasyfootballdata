class UserTeamsController < ApplicationController
  def index
    current_user.fetch_teams
    @teams = current_user.teams
  end
end
