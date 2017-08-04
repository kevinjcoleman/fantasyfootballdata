class RosterController < ApplicationController
  def show
    @team = NflTeam.includes(:players).find(params[:team_id])
  end
end
