require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:luke)
    @non_admin = users(:brody)
    @not_activated = users(:unactivated)
  end

  test "index as including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2

    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      unless user == @not_activated
        assert_select 'a[href=?]', user_path(user), text: user.name
      end
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index displays only activated users" do
    log_in_as(@admin)
    get users_path

    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      if user == @admin # this user activated
        assert_select 'a[href=?]', user_path(user), count: 1
      elsif user == @not_activated # this user not activated
        assert_select 'a[href=?]', user_path(user), count: 0
      end
    end
  end

end
