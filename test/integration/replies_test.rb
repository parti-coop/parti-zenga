require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create replies" do
    log_in_as_user

    fixture_updated_at = comment(:comment1).status.updated_at

    Timecop.freeze(Date.today + 30) do
      post status_replies_path(status_id: comment(:comment1).status, reply: { contents: 'reply sample' })
    end
    assert_redirected_to issue_path(issue(:one))

    assert_equal 'reply sample', assigns(:reply).contents
    assert_equal users(:user), assigns(:reply).user
    assert_equal comment(:comment1).status, assigns(:reply).status
    assert_not_equal fixture_updated_at, assigns(:status).updated_at
  end

  test "cannot create a reply by anonymous user" do
    post status_replies_path(status_id: comment(:comment1).status, reply: { contents: 'reply sample' })
    follow_redirect!
    assert_equal new_user_session_path, path
  end

  test "replies with link" do
    log_in_as_user

    post status_replies_path(status_id: comment(:comment2).status, reply: { contents: 'reply sample http://ogp.me' })

    assert_equal 'reply sample http://ogp.me', assigns(:reply).contents
    assert_equal 'http://ogp.me', assigns(:reply).links[0].url
    assert_equal 'Open Graph protocol', assigns(:reply).links[0].title
    assert_equal 'The Open Graph protocol enables any web page to become a rich object in a social graph.',
                 assigns(:reply).links[0].description
    assert_equal 'http://ogp.me/logo.png',
                 assigns(:reply).links[0].image
    assert_equal assigns(:reply).links[0], comment(:comment2).proposition.reload.links[0]
  end
end
