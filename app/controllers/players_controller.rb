class PlayersController < ApplicationController
  def duplicates
    @duplicates = Player.where.not(espn_id: nil).where(yahoo_key: nil)
  end

  def merge
    PlayerMerger.new(Player.find(params[:player1]),
                 Player.find(params[:player2])).merge!
    redirect_to duplicates_path
  end
end
