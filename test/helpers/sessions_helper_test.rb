require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:luke)
    remember @user
  end

  test "remember me via permanent session cookies" do
    # ie current_user returns right user when session is nil
    assert_equal current_user, @user
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end
