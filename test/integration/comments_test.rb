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

  test "comment with link" do
    log_in_as_user

    post issue_comments_path(issue_id: issue(:one),
                             comment: { contents: 'content sample http://ogp.me', proposition_id: proposition(:solution1) })
    assert_redirected_to issue_path(issue(:one))

    assert_equal 'content sample http://ogp.me', assigns(:comment).contents
    assert_equal 'http://ogp.me', assigns(:comment).links[0].url
    assert_equal 'Open Graph protocol', assigns(:comment).links[0].title
    assert_equal 'The Open Graph protocol enables any web page to become a rich object in a social graph.',
                 assigns(:comment).links[0].description
    assert_equal 'http://ogp.me/logo.png',
                 assigns(:comment).links[0].image
    assert_equal assigns(:comment).links[0], proposition(:solution1).reload.links[0]

    link_id = assigns(:comment).links[0].id
    post issue_comments_path(issue_id: issue(:one),
                             comment: { contents: 'content sample2 http://ogp.me' })
    assert_equal link_id, assigns(:comment).links[0].id
  end

  test "anonymous user cannot create a comment" do
    post issue_comments_path(issue_id: issue(:one),
                             comment: { contents: 'content sample' })
    follow_redirect!
    assert_equal new_user_session_path, path
  end
end
