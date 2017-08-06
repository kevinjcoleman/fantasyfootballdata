class PlayerSeasonController < ApplicationController
  before_action :find_player
  def index
  end

  def find_player
    @player = Player.find(params[:player_id])
    @seasons = @player.player_seasons.order(season: :DESC)
  end
end
