require 'test_helper'

class RoundsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:emlyn)
  end
  
  test "should redirect index when not logged in" do
    get rounds_path
    assert_redirected_to login_url
  end 
end
