require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:luke)
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: {user: {name: "bucky barnes", email: "abc@gmail.com", password: "password", password_confirmation: "abc123"}}
    assert_template 'users/edit'

    assert_select 'div.alert-danger', 'The form contains 1 error.'
  end

  test "successful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_equal @user.email, "lukey@example.com"

    patch user_path(@user), params: {user: {name: "luke", email: "abc@gmail.com", password: "", password_confirmation: ""}}
    follow_redirect!
    assert_template 'users/show'
    assert_not_empty flash[:success]

    @user.reload
    assert_equal @user.email, "abc@gmail.com"
  end

  test "friendly forwarding" do
    get edit_user_path(@user)
    assert_redirected_to login_path

    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as @user
    assert_redirected_to edit_user_url @user
    assert_nil session[:forwarding_url]
  end

end
