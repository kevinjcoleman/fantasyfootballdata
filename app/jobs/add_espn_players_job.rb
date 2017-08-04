class AddEspnPlayersJob < ApplicationJob
  attr_accessor :doc
  def run!
    NflTeam.find_each do |team|
      players_array = RosterParser.parse!(WebDocument.new(team.roster_url).doc)
      add_players(players_array, team)
    end
  end

  EXCEPTED_POSITIONS = %w(QB RB TE WR FB)

  def add_players(players_array, team)
    players_array.select {|hsh| hsh[:position].in?(EXCEPTED_POSITIONS)}.each {|hsh| Player.add_from_website(hsh, team) }
  end
end
