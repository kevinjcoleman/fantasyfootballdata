require 'test_helper'

class RosterControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get roster_show_url
    assert_response :success
  end

end
