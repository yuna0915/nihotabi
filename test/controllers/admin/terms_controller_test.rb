require "test_helper"

class Admin::TermsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_terms_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_terms_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_terms_update_url
    assert_response :success
  end
end
