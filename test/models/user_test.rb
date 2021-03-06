require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar", default_bowtype: "Longbow", gender: "Male", date_of_birth: Date.parse("1990-01-01"))
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@fool.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_addresses|
      @user.email = valid_addresses
      assert @user.valid?, "#{valid_addresses.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email address should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.COM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "passwords should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "gender should be present" do
    @user.gender = nil
    assert_not @user.valid?
  end
  
  test "gender should be an expected value" do
    @user.gender = "Mayo"
    assert_not @user.valid?
  end
  
  test "default bowtype should be present" do
    @user.default_bowtype = nil
    assert_not @user.valid?
  end
  
  test "default bowtype should be an expected value" do
    @user.default_bowtype = "Crossbow"
    assert_not @user.valid?
  end
  
  test "date of birth cannot be after today" do
    @user.date_of_birth = Date.tomorrow
    assert_not @user.valid?
  end
  
  test "date of birth cannot be before 1900" do
    @user.date_of_birth = Date.parse("1899-12-31")
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    emlyn       = users(:emlyn)
    other_user  = users(:user_5)
    assert_not emlyn.following?(other_user)
    assert_not other_user.followers.include?(emlyn)
    emlyn.follow(other_user)
    assert emlyn.following?(other_user)
    assert other_user.followers.include?(emlyn)
    emlyn.unfollow(other_user)
    assert_not emlyn.following?(other_user)
    assert_not other_user.followers.include?(emlyn)
  end
  
  test "feed should have the right posts" do
    emlyn           = users(:emlyn)
    followed_user   = users(:test)
    unfollowed_user = users(:user_5)
    # Posts from followed user
    followed_user.microposts.each do |post_following|
      assert emlyn.feed.include?(post_following)
    end
    # Posts from self
    emlyn.microposts.each do |post_self|
      assert emlyn.feed.include?(post_self)
    end
    # Posts from unfollowed user
    unfollowed_user.microposts.each do |post_unfollowed|
      assert_not emlyn.feed.include?(post_unfollowed)
    end
  end
end
