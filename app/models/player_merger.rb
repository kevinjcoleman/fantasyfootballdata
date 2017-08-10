class PlayerMerger
  attr_accessor :player1, :player2

  def self.find_duplicate_players
    Player.select("name, team_id").group(:name, :team_id).having("count(id) > 1").each do |plyr|
      players = Player.where(name: plyr.name, team_id: plyr.team_id)
      yahoo_players = players.where(espn_id: nil).where.not(yahoo_key: nil)
      espn_player = players.where(yahoo_key: nil).where.not(espn_id: nil)
      raise "Duplicate espn players" if espn_player.count > 1; raise "No espn player" unless espn_player
      yahoo_players.each do |yp|
        new(espn_player.first, yp).merge!
      end
    end
  end

  def initialize(player1, player2)
    @player1, @player2 = player1, player2
  end

  def merge!
    raise "Player 1 must not have a yahoo key" if player1.yahoo_key
    begin
      player2.destroy
      player1.update_attributes(attrs)
    rescue => e
      "Player #{player2.id}\nerror: #{e.message}"
    end
  end

  def attrs
    player2.attributes.slice(:image_url, :yahoo_key)
  end
end
