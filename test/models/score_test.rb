require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  def setup
    @user         = users(:emlyn)
    @round        = rounds(:wa1440g)
    @od_imp_round = rounds (:york)
    @category = categories(:sen_gents_barebow)
    @score = @user.scores.build(score: 1, 
                       hits: 1,
                       round_id: @round.id,
                       location: "somewhere",
                       bowtype: "Barebow",
                       date: Date.today)
  end

  test "should be valid" do
    assert @score.valid?
  end

  test "user id should be present" do
    @score.user_id = nil
    assert_not @score.valid?
  end
  
  test "round id should be present" do
    @score.round_id = nil
    assert_not @score.valid?
  end
  
  test "Bowtype should be present" do
    @score.bowtype = nil
    assert_not @score.valid?
  end
  
  test "Bowtype can only be an expected value" do
    @score.bowtype = "Compound"
    assert @score.valid?
    @score.bowtype = "Longbow"
    assert @score.valid?
    @score.bowtype = "Recurve"
    assert @score.valid?
    @score.bowtype = "Crossbow"
    assert_not @score.valid?
  end
  
  test "score should be present" do
    @score.score = nil
    assert_not @score.valid?
  end
  
  test "hits should be present" do
    @score.hits = nil
    assert_not @score.valid?
  end
  
  test "location should be present" do
    @score.location = nil
    assert_not @score.valid?
  end  
  
  test "date should be present" do
    @score.date = nil
    assert_not @score.valid?
  end
  
  test "date cannot be in the future" do
    @score.date = Date.tomorrow
    assert_not @score.valid?
  end
  
  test "date cannot be before users birthday" do
    @score.date = @user.date_of_birth - 1
    assert_not @score.valid?
  end
  
  test "record status can only be an expected value or nil" do
    @score.record_status = "none"
    assert @score.valid?
    @score.record_status = "ukrs"
    assert @score.valid?
    @score.record_status = "wrs"
    assert @score.valid?
    @score.record_status = "blah"
    assert_not @score.valid?
  end
  
  test "score cannot be higher than round max score" do
    @score.score = 1441
    assert_not @score.valid?
  end
  
  test "hits cannot be higher than round max hits" do
    @score.hits = 145
    assert_not @score.valid?
  end
  
  test "golds cannot be higher than hits" do
    @score.hits = 1
    @score.golds = 2
    assert_not @score.valid?
  end
  
  test "xs cannot be higher than golds" do
    @score.golds = 1
    @score.xs = 2
    assert_not @score.valid?
  end
    
  test "score cannot be more than golds * max arrow value and hits  - golds * max arrow value - 1" do
    @score.score = 11
    @score.hits = 1
    @score.golds = 1
    assert_not @score.valid?
  end  
  
  test "score cannot be less than golds * by max arrow value + hits * min arrow value (1)" do
    @score.score = 11
    @score.hits = 3
    @score.golds = 1
    assert_not @score.valid?
  end
  
  test "outdoor imperial round cannot have odd hits and even score, or even hits and odd score" do
    @score.round_id = @od_imp_round.id
    @score.score = 2
    @score.hits = 1
    assert_not @score.valid?
    @score.score = 3
    @score.hits = 2
    assert_not @score.valid?
  end
end
