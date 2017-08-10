require 'test_helper'

class LeaguePlayersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get league_players_index_url
    assert_response :success
  end

  test "should get show" do
    get league_players_show_url
    assert_response :success
  end

end
