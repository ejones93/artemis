require 'test_helper'

class ScoresInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:emlyn)
    @round = rounds(:wa1440g)
  end
  
  test "score interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    comment = "This should be here"
    # Invalid submission
    assert_no_difference 'Score.count' do
      post scores_path, params: { score: { score: 0, 
                                           hits: 1,
                                           round_id: @round.id,
                                           location: "somewhere",
                                           bowtype: "Barebow",
                                           date: Date.today } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2' # Correct pagination link
    # Valid submission
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference 'Score.count', 1 do
      post scores_path, params: { score: { score: 1, 
                                           hits: 1,
                                           round_id: @round.id,
                                           location: "somewhere",
                                           bowtype: "Barebow",
                                           date: Date.today, 
                                           comment: comment,
                                           image: image} }
    end
    assert @user.scores.first.image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_match comment, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_score = @user.scores.paginate(page: 1).first
    assert_difference 'Score.count', -1 do
      delete score_path(first_score)
    end
    # Visit different user (no delete links)
    # get user_path(users(:test))
    # assert_select 'a', text: 'delete', count: 0
  end
  
  test "score sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match @user.scores.count.to_s + " score", response.body
    # User with zero scores
    other_user = users(:noposts)
    log_in_as(other_user)
    get root_path
    assert_match "0 scores", response.body
    other_user.scores.create!(score: 1, 
                              hits: 1,
                              round_id: @round.id,
                              location: "somewhere",
                              bowtype: "Barebow",
                              date: Date.today)
    get root_path
    assert_match "1 score", response.body
  end
end
