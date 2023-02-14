require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: { 
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar" 
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 4 errors.'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: { 
          name: "foobar",
          email: "user@valid.com",
          password: "pass123",
          password_confirmation: "pass123" 
        }
      }
    end
    follow_redirect!
    #assert_template 'users/show'

    assert_not flash.empty?
    assert_not flash[:info].blank?
    #assert is_logged_in?
  end

end
