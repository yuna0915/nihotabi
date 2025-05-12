require "test_helper"

class Admin::VisitedMonthsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_visited_months_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_visited_months_edit_url
    assert_response :success
  end
end
