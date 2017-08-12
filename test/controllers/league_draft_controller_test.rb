require 'test_helper'

class LeagueDraftControllerTest < ActionDispatch::IntegrationTest
  test "should get league:references" do
    get league_draft_league:references_url
    assert_response :success
  end

  test "should get runs:integer" do
    get league_draft_runs:integer_url
    assert_response :success
  end

end
