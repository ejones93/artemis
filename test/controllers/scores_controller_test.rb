require 'test_helper'

class ScoresControllerTest < ActionDispatch::IntegrationTest
  def setup
    @score =      scores(:emlyn_york)
    @round =      rounds(:wa1440g)
    @non_admin =  users(:test)
    @admin =      users(:emlyn)
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Score.count' do
      post scores_path, params: { score: { score: 1, 
                                           hits: 1,
                                           round_id: @round.id,
                                           location: "somewhere",
                                           bowtype: "Barebow",
                                           date: Date.today } }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Score.count' do
      delete score_path(@score)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not admin" do
    log_in_as(@non_admin)
    assert_no_difference 'Score.count' do
      delete score_path(@score)
    end
    assert_redirected_to root_url
  end

  test "should destroy when admin" do
    log_in_as(@admin)
    assert_difference 'Score.count', -1 do
      delete score_path(@score)
    end
    assert_redirected_to root_url
  end
end
