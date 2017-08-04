class Player < ApplicationRecord
  belongs_to :team, class_name: 'NflTeam'

  def self.add_from_website(hsh, team)
    where(espn_id: hsh[:espn_id]).first_or_create.tap do |plyr|
      RosterParser::ROW_HEADERS.values.push(:espn_slug).each do |attr|
        plyr.send("#{attr.to_s}=", hsh[attr])
      end
      plyr.team = team
      plyr.save!
    end
  end

  def backfill_stats
    # RB Stats http://www.espn.com/nfl/player/splits/_/id/3051392/ezekiel-elliott
    # QB Stats http://www.espn.com/nfl/player/splits/_/id/2577417/year/2016
    # WR Stats http://www.espn.com/nfl/player/splits/_/id/13215/year/2010
  end
end
