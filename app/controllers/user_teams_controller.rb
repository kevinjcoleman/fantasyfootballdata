class UserTeamsController < ApplicationController
  def index
    @teams = current_user.teams['fantasy_content']['users']['user']['teams']['team']
  end

  def show
  end
end
