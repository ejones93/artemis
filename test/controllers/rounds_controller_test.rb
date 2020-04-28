require 'test_helper'

class RoundsControllerTest < ActionDispatch::IntegrationTest
  test "rounds path should load" do
    get rounds_path
    assert_response :success
  end 
end
