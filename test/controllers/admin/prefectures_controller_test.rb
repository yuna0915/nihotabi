require "test_helper"

class Admin::PrefecturesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_prefectures_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_prefectures_edit_url
    assert_response :success
  end
end
