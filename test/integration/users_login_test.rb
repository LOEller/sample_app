require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:luke)
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: @user.email, password: "abc123" } }
    assert_template 'sessions/new'
    assert flash[:danger].present?
    assert_not is_logged_in?

    get root_path
    assert flash[:danger].blank?
  end

  test "layout links change after valid login" do
    get login_path
    assert_template 'sessions/new'
    assert_select "a[href=?]", login_path

    post login_path, params: { session: { email: @user.email, password: "pass123"}}

    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'

    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "logout" do
    post login_path, params: { session: { email: @user.email, password: "pass123"}}
    assert_redirected_to @user
    follow_redirect!
    assert is_logged_in?

    delete logout_path
    assert_redirected_to root_path
    follow_redirect!

    assert_not is_logged_in?
    assert_template "static_pages/home"
  end

end
