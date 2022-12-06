require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:luke)
    @another_user = users(:brody)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@admin_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@admin_user), params: { user: { name: @admin_user.name, email: @admin_user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when wrong user logged in" do
    log_in_as @admin_user
    get edit_user_path @another_user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when wrong user logged in" do
    log_in_as @admin_user
    patch user_path(@another_user), params: { user: { name: @admin_user.name, email: @admin_user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "user admin attribute is not editable through the web" do
    log_in_as @another_user
    assert !@another_user.admin?

    patch user_path(@another_user), params: { user: { admin: true } }
    assert !@another_user.reload.admin?
  end

  test "should redirect delete when not logged in" do 
    assert_no_difference 'User.count' do
      delete user_path(@another_user)
    end
    assert_redirected_to login_url
  end

  test "should redirect delete when logged in not admin" do
    log_in_as @another_user
    assert_no_difference 'User.count' do
      delete user_path(@another_user)
    end
    assert_redirected_to root_url
  end

end
