require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create replies" do
    log_in_as_user

    post status_replies_path(status_id: comment(:comment1).status, reply: { contents: 'reply sample' })
    assert_redirected_to issue_path(issue(:one))

    assert_equal 'reply sample', assigns(:reply).contents
    assert_equal users(:user), assigns(:reply).user
    assert_equal comment(:comment1).status, assigns(:reply).status
  end

  test "cannot create a reply by anonymous user" do
    post status_replies_path(status_id: comment(:comment1).status, reply: { contents: 'reply sample' })
    follow_redirect!
    assert_equal new_user_session_path, path
  end
end
