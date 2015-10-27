require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create comment" do
    log_in_as_user

    post issue_comments_path(issue_id: issue(:one),
                             comment: { contents: 'content sample' })
    assert_redirected_to issue_path(issue(:one))

    assert_equal assigns(:comment).contents, 'content sample'
    assert_equal assigns(:comment).user, users(:user)
    assert_equal assigns(:comment).status.source, assigns(:comment)
  end

  test "anonymous user cannot create a comment" do
    post issue_comments_path(issue_id: issue(:one),
                             comment: { contents: 'content sample' })
    follow_redirect!
    assert_equal new_user_session_path, path
  end
end
