require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:luke)
  end

  test "layout links logged in user" do
    log_in_as @user
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    get help_path
    assert_select "title", full_title("Help")
    get users_path 
    assert_select "title", full_title("All users")
    get user_path(@user)
    assert_select "title", full_title(@user.name)
    get edit_user_path(@user)
    assert_select "title", full_title("Edit user")
  end

  test "layout links non logged in user" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path 
    assert_select "title", full_title("Sign up")
  end

end
