require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @inactive_user  = users(:inactive)
    @activated_user = users(:test)
    @admin = users(:emlyn)
  end
  
  test "should redirect to root_url when user not activated" do
    log_in_as(@admin)
    get user_path(@inactive_user)
    assert_redirected_to root_url
  end
  
  test "should display user when activated" do
    log_in_as(@admin)
    get user_path(@activated_user)
    assert_template 'users/show'
    assert_response :success
  end  
end
