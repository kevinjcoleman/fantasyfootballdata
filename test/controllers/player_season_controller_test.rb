require 'test_helper'

class PlayerSeasonControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get player_season_show_url
    assert_response :success
  end

end
