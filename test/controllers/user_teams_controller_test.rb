require 'test_helper'

class UserTeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_teams_index_url
    assert_response :success
  end

  test "should get show" do
    get user_teams_show_url
    assert_response :success
  end

end
