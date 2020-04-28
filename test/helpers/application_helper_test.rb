require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "Artemis Scoring System"
    assert_equal full_title("Help"), "Help | Artemis Scoring System" 
  end
end