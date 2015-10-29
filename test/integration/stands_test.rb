require 'test_helper'

class StandsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "stands" do
    log_in_as_user

    get new_proposition_stand_path issue_id: issue(:one), proposition_id: proposition(:solution1)
    assert_response :success

    stand_in_favor
    assert_redirected_to issue_path(issue(:one))

    assert_equal 'in_favor', assigns(:stand).choice
    assert_equal users(:user), assigns(:stand).user
    assert_equal 'in_favor', fetch_current_stand.choice

    assert_equal assigns(:stand).status.source, assigns(:stand)

    stand_oppose
    assert_equal 'oppose', assigns(:stand).choice
    assert_equal users(:user), assigns(:stand).user
    assert_equal 'oppose', fetch_current_stand.choice

    # assert_equal assigns(:stand).status.source, assigns(:proposition)
  end

  test "same stands" do
    log_in_as_user

    stand_in_favor
    assert_redirected_to issue_path(issue(:one))

    assert_equal 'in_favor', assigns(:stand).choice
    assert_equal users(:user), assigns(:stand).user
    assert_equal 'in_favor', fetch_current_stand.choice

    first_stand = fetch_current_stand

    stand_in_favor
    assert_equal first_stand, fetch_current_stand
  end

  test "current stands count" do
    log_in_as_user

    stand_in_favor

    first_count = proposition(:solution1).count_stands('in_favor')
    stand_oppose
    stand_in_favor
    stand_oppose

    stand_in_favor
    assert_equal first_count, proposition(:solution1).count_stands('in_favor')
  end

  test "stands with comment" do
    log_in_as_user

    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'in_favor' },
                                 has_comment: 1,
                                 comment: { contents: 'test comment1'} )
    assert_equal 'test comment1', assigns(:comment).contents
    assert_equal proposition(:solution1), assigns(:comment).proposition

    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'oppose' },
                                 comment: { contents: 'test comment2'} )
    assert_equal nil, assigns(:comment)
  end

  test "anonymous user cannot create a stand" do
    stand_in_favor
    follow_redirect!
    assert_equal new_user_session_path, path
  end

  def stand_in_favor
    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'in_favor' })
  end

  def stand_oppose
    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'oppose' })
  end

  def fetch_current_stand
    proposition(:solution1).stand(users(:user))
  end
end
