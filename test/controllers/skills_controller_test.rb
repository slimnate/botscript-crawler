require 'test_helper'

class SkillsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get skills_index_url
    assert_response :success
  end

  test "should get detail" do
    get skills_detail_url
    assert_response :success
  end

end
