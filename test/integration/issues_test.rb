require 'test_helper'

class IssuesTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create issue" do
    log_in_as_user
    get new_issue_path
    assert_response :success

    post issues_path, issue: { title: 'three' }
    assert_equal assigns(:issue).user, users(:user)
    assert_redirected_to issue_path(assigns(:issue))
  end

  test "anonymous user cannot create a issue" do
    get new_issue_path
    follow_redirect!
    assert_equal new_user_session_path, path
  end
end
