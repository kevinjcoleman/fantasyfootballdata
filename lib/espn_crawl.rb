require 'nokogiri'
require 'pry'
require 'HTTParty'
require "pstore"

def open_url(url)
  Nokogiri::HTML(HTTParty.get(url))
end


def parse_stats_row(row, headers)
  stats = {}
  row.children.each_with_index do |td, j|
    next if td.css('.redfont').any?
    if td.css('a').any?
      stats[headers[j]] = td.css('a').first.content
    elsif td.css('.redfont').any?
    else
      stats[headers[j]] = td.content
    end
  end
  stats = nil if stats['date'] == 'REGULAR SEASON STATS'
  stats
end

def parse_stats_table(doc)
  return nil if doc.css('td').last.content == "No stats available."
  table = doc.css('.tablehead')
  games = {}
  table.children.each_with_index do |row, i|
    if i == 1
      @headers = obtain_headers(row)
    elsif row['class'] == 'stathead'
      break if !row.children.first.content.include?("REGULAR SEASON")
    else
      result = parse_stats_row(row, @headers)
      break if !result || results.empty?
      games[i] = result
    end
  end
  games
end

# http://www.espn.com/nfl/player/gamelog/_/id/14163/year/2015
@players.first[1].each_with_index do |player_hash, i|
  @players.first[1][i]['seasons'] = {}
  next if player_hash['exp'] == 'R'
  doc = open_url("http://www.espn.com/nfl/player/gamelog/_/id/#{player_hash['espn_id']}/year/2016")
  @players.first[1][i]['seasons'][2016] = parse_stats_table(doc)
  1.upto(player_hash['exp'].to_i - 1) do |playing_year|
    year = 2016 - playing_year
    doc = open_url("http://www.espn.com/nfl/player/gamelog/_/id/#{player_hash['espn_id']}/year/#{year}")
    @players.first[1][i]['seasons'][year] = parse_stats_table(doc)
  end
  p @players.first[1][i]
end

binding.pry
