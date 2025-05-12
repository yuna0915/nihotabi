require "test_helper"

class Admin::LocationGenresControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_location_genres_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_location_genres_edit_url
    assert_response :success
  end
end
