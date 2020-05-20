require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clients_index_url
    assert_response :success
  end

  test "should get detail" do
    get clients_detail_url
    assert_response :success
  end

end
