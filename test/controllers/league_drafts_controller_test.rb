require 'test_helper'

class LeagueDraftsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get league_drafts_create_url
    assert_response :success
  end

  test "should get destroy" do
    get league_drafts_destroy_url
    assert_response :success
  end

end
