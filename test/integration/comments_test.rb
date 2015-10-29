require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create comment" do
    log_in_as_user

    post issue_comments_path(issue_id: issue(:one),
                             comment: { contents: 'content sample' })
    assert_redirected_to issue_path(issue(:one))

    assert_equal 'content sample', assigns(:comment).contents
    assert_equal users(:user), assigns(:comment).user
    assert_equal assigns(:comment), assigns(:comment).status.source
  end

  test "comment with proposition" do
    log_in_as_user

    post issue_comments_path(issue_id: issue(:one),
                             comment: { contents: 'content sample', proposition_id: proposition(:solution1) })
    assert_redirected_to issue_path(issue(:one))
    assert_equal proposition(:solution1), assigns(:comment).proposition
  end

  test "anonymous user cannot create a comment" do
    post issue_comments_path(issue_id: issue(:one),
                             comment: { contents: 'content sample' })
    follow_redirect!
    assert_equal new_user_session_path, path
  end
end
