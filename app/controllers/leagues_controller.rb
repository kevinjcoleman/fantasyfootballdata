class LeaguesController < ApplicationController
  def show
    @league = League.includes(:teams).find(params[:id])
    load_team
    redirect_to root_path unless @team
    LeagueLoader.new(@league, current_user)
  end

  private
    def load_team
      @team = current_user.teams.where(league_id: @league.id).first
    end
end
