class AddNflTeamsJob < ApplicationJob
  attr_accessor :doc
  def run!
    @doc = WebDocument.new('http://www.espn.com/nfl/teams').doc
    get_roster_slugs.each do |short_slug, long_slug|
      team_name = find_team_name(short_slug, long_slug)
      NflTeam.where(espn_slug: long_slug, name: team_name, espn_short_slug: short_slug).first_or_create
    end
  end

  def get_roster_slugs
    doc.xpath('//a[contains(text(), "Roster")]').map {|node| node['href'].split('name/').last.split("/") }
  end

  def find_team_name(short_slug, long_slug)
    team_roster = WebDocument.new("http://www.espn.com/nfl/team/roster/_/name/#{short_slug}/#{long_slug}").doc
    team_roster.css('.sub-brand-title').children.first.content
  end
end
