require "test_helper"

class Public::TermsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_terms_show_url
    assert_response :success
  end
end
