class AddYahooPlayersJob < ApplicationJob
  attr_accessor :players
  def initialize
    @players = YahooPlayerLoader.new(User.first, League.first).players
  end

  def run!
    remove_unwanted_positions
    players.each do |player|
      begin
        team = NflTeam.find_by(espn_short_slug: player.team)
        plyr = Player.find_by(yahoo_key: player.key) || Player.where(name: player.full_name, team_id: team.id).first_or_create
        plyr.image_url = player.image
        plyr.position = player.position unless plyr.position
        plyr.yahoo_key = player.key unless plyr.yahoo_key
        plyr.save!
      rescue => e
        puts "Error with #{player.full_name}: #{e.message}"
      end
    end
  end

  UNWANTED_POSITIONS = %w(K DEF)

  def remove_unwanted_positions
    @players = players.select {|player| !player.position.in?(UNWANTED_POSITIONS)}
  end
end
