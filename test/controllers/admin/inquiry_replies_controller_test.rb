require "test_helper"

class Admin::InquiryRepliesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get admin_inquiry_replies_create_url
    assert_response :success
  end
end
