require "test_helper"

class Admin::MasterDataControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_master_data_index_url
    assert_response :success
  end
end
