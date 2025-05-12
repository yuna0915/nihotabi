require "test_helper"

class Admin::VisitedTimeZonesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_visited_time_zones_new_url
    assert_response :success
  end
end
