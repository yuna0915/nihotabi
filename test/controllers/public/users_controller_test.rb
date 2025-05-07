require "test_helper"

class Public::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get my_page" do
    get public_users_my_page_url
    assert_response :success
  end

  test "should get edit" do
    get public_users_edit_url
    assert_response :success
  end

  test "should get show" do
    get public_users_show_url
    assert_response :success
  end

  test "should get update" do
    get public_users_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_users_destroy_url
    assert_response :success
  end

  test "should get followings" do
    get public_users_followings_url
    assert_response :success
  end

  test "should get followers" do
    get public_users_followers_url
    assert_response :success
  end
end
