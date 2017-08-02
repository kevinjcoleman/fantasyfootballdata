require 'nokogiri'
require 'pry'
require 'HTTParty'
require "pstore"

def open_url(url)
  Nokogiri::HTML(HTTParty.get(url))
end

doc = open_url('http://www.espn.com/nfl/teams')

roster_urls = doc.xpath('//a[contains(text(), "Roster")]').
             map {|node| "http://www.espn.com#{node['href']}" }

def obtain_headers(row)
  headers = []
  row.children.each_with_index do |td, j|
    if td.css('a').any?
      headers[j] = td.css('a').first.content.downcase
    else
      headers[j] = td.content.downcase
    end
  end
  headers
end

def parse_player_row(row, headers)
  player = {}
  row.children.each_with_index do |td, j|
    if td.css('a').any?
      player[headers[j]] = td.css('a').first.content
      player['espn_id'] = td.css('a').first['href'].match(/id\/(\d+)\//)[1].to_i
    else
      player[headers[j]] = td.content
    end
  end
  player
end

@players = {}

roster_urls.each do |roster_url|
  doc = open_url(roster_url)
  team = doc.css('.sub-brand-title').children.first.content
  @players[team] = []
  doc.css('table').children.each_with_index do |row, i|
    if i == 1 && !@headers
      @headers = obtain_headers(row)
    elsif row['class'] == 'stathead'
      @position = row.content
    elsif row['class'] != "colhead"
      @players[team][i] = parse_player_row(row, @headers)
    end
  end
  @players[team] = @players[team].compact
  break if @players.count > 1
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
