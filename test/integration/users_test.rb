require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "log in/out" do
    get new_user_session_path
    assert_response :success

    post new_user_session_path, user: { email: users(:user).email, :password => '12345678' }
    follow_redirect!
    assert_equal root_path, path
    assert_select '.user--current__email', users(:user).email

    delete destroy_user_session_path
    follow_redirect!
    assert_equal root_path, path
    assert_select '.user--current__email', false
  end

  test "register user" do
    user_email = 'test@gmail.com'
    post user_registration_path, user: { email: user_email, password: '12345678', password_confirmation: '12345678'}
    follow_redirect!
    assert_equal root_path, path
    assert_select '.user--current__email', user_email
  end
end
