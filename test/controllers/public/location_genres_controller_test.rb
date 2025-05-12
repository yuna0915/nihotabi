require "test_helper"

class Public::LocationGenresControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_location_genres_show_url
    assert_response :success
  end
end
