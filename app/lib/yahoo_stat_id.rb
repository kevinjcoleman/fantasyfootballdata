module YahooStatId
  STATS = [{"stat_id"=>"0", "name"=>"games_played"},
           {"stat_id"=>"1", "name"=>"passing_attempts"},
           {"stat_id"=>"2", "name"=>"passing_completions"},
           {"stat_id"=>"4", "name"=>"passing_yards"},
           {"stat_id"=>"5", "name"=>"passing_touchdowns"},
           {"stat_id"=>"6", "name"=>"passing_interceptions"},
           {"stat_id"=>"8", "name"=>"rushing_attempts"},
           {"stat_id"=>"9", "name"=>"rushing_yards"},
           {"stat_id"=>"10", "name"=>"receiving_touchdowns"},
           {"stat_id"=>"11", "name"=>"receptions"},
           {"stat_id"=>"12", "name"=>"receiving_yards"},
           {"stat_id"=>"13", "name"=>"receiving_touchdowns"},
           #{"stat_id"=>"14", "name"=>"Return Yards"},
           #{"stat_id"=>"15", "name"=>"Return Touchdowns"},
           #{"stat_id"=>"16", "name"=>"2-Point Conversions"},
           {"stat_id"=>"17", "name"=>"fumbles"},
           {"stat_id"=>"18", "name"=>"fumbles_lost"}]
           #{"stat_id"=>"19", "name"=>"Field Goals 0-19 Yards"},
           #{"stat_id"=>"20", "name"=>"Field Goals 20-29 Yards"},
           #{"stat_id"=>"21", "name"=>"Field Goals 30-39 Yards"},
           #{"stat_id"=>"22", "name"=>"Field Goals 40-49 Yards"},
           #{"stat_id"=>"23", "name"=>"Field Goals 50+ Yards"},
           #{"stat_id"=>"24", "name"=>"Field Goals Missed 0-19 Yards"},
           #{"stat_id"=>"25", "name"=>"Field Goals Missed 20-29 Yards"},
           #{"stat_id"=>"26", "name"=>"Field Goals Missed 30-39 Yards"},
           #{"stat_id"=>"27", "name"=>"Field Goals Missed 40-49 Yards"},
           #{"stat_id"=>"28", "name"=>"Field Goals Missed 50+ Yards"},
           #{"stat_id"=>"29", "name"=>"Point After Attempt Made"},
           #{"stat_id"=>"30", "name"=>"Point After Attempt Missed"},
           #{"stat_id"=>"31", "name"=>"Points Allowed"},
           #{"stat_id"=>"32", "name"=>"Sack"},
           #{"stat_id"=>"33", "name"=>"Interception"},
           #{"stat_id"=>"34", "name"=>"Fumble Recovery"},
           #{"stat_id"=>"35", "name"=>"Touchdown"},
           #{"stat_id"=>"36", "name"=>"Safety"},
           #{"stat_id"=>"37", "name"=>"Block Kick"},
           #{"stat_id"=>"38", "name"=>"Tackle Solo"},
           #{"stat_id"=>"39", "name"=>"Tackle Assist"},
           #{"stat_id"=>"40", "name"=>"Sack"},
           #{"stat_id"=>"41", "name"=>"Interception"},
           #{"stat_id"=>"42", "name"=>"Fumble Force"},
           #{"stat_id"=>"43", "name"=>"Fumble Recovery"},
           #{"stat_id"=>"44", "name"=>"Defensive Touchdown"},
           #{"stat_id"=>"45", "name"=>"Safety"},
           #{"stat_id"=>"46", "name"=>"Pass Defended"},
           #{"stat_id"=>"47", "name"=>"Block Kick"},
           #{"stat_id"=>"48", "name"=>"Return Yards"},
           #{"stat_id"=>"49", "name"=>"Kickoff and Punt Return Touchdowns"},
           #{"stat_id"=>"50", "name"=>"Points Allowed 0 points"},
           #{"stat_id"=>"51", "name"=>"Points Allowed 1-6 points"},
           #{"stat_id"=>"52", "name"=>"Points Allowed 7-13 points"},
           #{"stat_id"=>"53", "name"=>"Points Allowed 14-20 points"},
           #{"stat_id"=>"54", "name"=>"Points Allowed 21-27 points"},
           #{"stat_id"=>"55", "name"=>"Points Allowed 28-34 points"},
           #{"stat_id"=>"56", "name"=>"Points Allowed 35+ points"},
           #{"stat_id"=>"57", "name"=>"Offensive Fumble Return TD"},
           #{"stat_id"=>"58", "name"=>"Pick Sixes Thrown"},
           #{"stat_id"=>"59", "name"=>"40+ Yard Completions"},
           #{"stat_id"=>"60", "name"=>"40+ Yard Passing Touchdowns"},
           #{"stat_id"=>"61", "name"=>"40+ Yard Run"},
           #{"stat_id"=>"62", "name"=>"40+ Yard Rushing Touchdowns"},
           #{"stat_id"=>"63", "name"=>"40+ Yard Receptions"},
           #{"stat_id"=>"64", "name"=>"40+ Yard Receiving Touchdowns"},
           #{"stat_id"=>"65", "name"=>"Tackles for Loss"},
           #{"stat_id"=>"66", "name"=>"Turnover Return Yards"},
           #{"stat_id"=>"67", "name"=>"4th Down Stops"},
           #{"stat_id"=>"68", "name"=>"Tackles for Loss"},
           #{"stat_id"=>"69", "name"=>"Defensive Yards Allowed"},
           #{"stat_id"=>"70", "name"=>"Defensive Yards Allowed - Negative"},
           #{"stat_id"=>"71", "name"=>"Defensive Yards Allowed 0-99"},
           #{"stat_id"=>"72", "name"=>"Defensive Yards Allowed 100-199"},
           #{"stat_id"=>"73", "name"=>"Defensive Yards Allowed 200-299"},
           #{"stat_id"=>"74", "name"=>"Defensive Yards Allowed 300-399"},
           #{"stat_id"=>"75", "name"=>"Defensive Yards Allowed 400-499"},
           #{"stat_id"=>"76", "name"=>"Defensive Yards Allowed 500+"},
           #{"stat_id"=>"77", "name"=>"Three and Outs Forced"},
           #{"stat_id"=>"78", "name"=>"Targets"},
           #{"stat_id"=>"79", "name"=>"Passing 1st Downs"},
           #{"stat_id"=>"80", "name"=>"Receiving 1st Downs"},
           #{"stat_id"=>"81", "name"=>"Rushing 1st Downs"},
           #{"stat_id"=>"82", "name"=>"Extra Point Returned"},
           #{"stat_id"=>"83", "name"=>"Extra Point Returned"}]
           
  def self.name_from_stat_id(stat_id)
    raise 'Unknown stat id' unless stat_id.in?(accepted_ids)
    stat = STATS.find {|hsh| hsh['stat_id'].to_i == stat_id.to_i }
    stat.dig "name"
  end

  def self.accepted_ids
    STATS.map {|hsh| hsh['stat_id'] }
  end
end
