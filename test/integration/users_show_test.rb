require "test_helper"

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:luke)
    @not_activated = users(:unactivated)
  end

  test "shows activated user" do
    log_in_as(@admin)
    get user_path(@admin)
    assert_template 'users/show'
  end

  test "does not show unactivated user" do
    log_in_as(@admin)
    get user_path(@not_activated)
    follow_redirect!
    assert_template 'static_pages/home'
  end

end
