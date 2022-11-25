require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "invalid login renders flash then goes away" do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert flash[:danger].present?

    get root_path
    assert flash[:danger].blank?
  end

end
