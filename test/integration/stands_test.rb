require 'test_helper'

class StandsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "stands" do
    log_in_as_user

    get new_proposition_stand_path issue_id: issue(:one), proposition_id: proposition(:solution1)
    assert_response :success

    stands_count = proposition(:solution1).stands_count
    in_favor
    assert_redirected_to issue_path(issue(:one))

    assert_equal 'in_favor', assigns(:stand).choice
    assert_equal users(:user), assigns(:stand).user
    assert_equal 'in_favor', fetch_current_stand.choice

    assert_equal assigns(:stand), assigns(:stand).status.source
    assert_equal stands_count + 1, proposition(:solution1).reload.stands_count

    oppose
    assert_equal 'oppose', assigns(:stand).choice
    assert_equal users(:user), assigns(:stand).user
    assert_equal 'oppose', fetch_current_stand.choice

    assert_equal stands_count + 1, proposition(:solution1).reload.stands_count
  end

  test "same stands" do
    log_in_as_user

    in_favor
    assert_redirected_to issue_path(issue(:one))

    assert_equal 'in_favor', assigns(:stand).choice
    assert_equal users(:user), assigns(:stand).user
    assert_equal 'in_favor', fetch_current_stand.choice

    first_stand = fetch_current_stand

    in_favor
    assert_equal first_stand, fetch_current_stand
  end

  test "current stands count" do
    log_in_as_user

    in_favor

    first_count = proposition(:solution1).stands_count_by('in_favor')
    oppose
    in_favor
    oppose

    in_favor
    assert_equal first_count, proposition(:solution1).stands_count_by('in_favor')
  end

  test "stands with description" do
    log_in_as_user

    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'in_favor', has_description: 1, description: 'test description1'} )
    assert_equal 'test description1', assigns(:stand).description

    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'oppose', has_description: 0, description: 'test description2' },
                                 comment: { contents: 'test comment2'} )
    assert_equal nil, assigns(:stand).description
  end

  test "stands with links" do
    log_in_as_user

    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'in_favor', has_description: 1, description: 'test description1 http://ogp.me'} )
    assert_equal 'test description1 http://ogp.me', assigns(:stand).description
    assert_equal 'http://ogp.me', assigns(:stand).links[0].url
    assert_equal 'Open Graph protocol', assigns(:stand).links[0].title
    assert_equal 'The Open Graph protocol enables any web page to become a rich object in a social graph.',
                 assigns(:stand).links[0].description
    assert_equal 'http://ogp.me/logo.png',
                 assigns(:stand).links[0].image
  end

  test "anonymous user cannot create a stand" do
    in_favor
    follow_redirect!
    assert_equal new_user_session_path, path
  end

  test "available choices" do
    log_in_as_user
    in_favor
    stand = fetch_current_stand

    new_stand = proposition(:solution1).stands.new
    assert_equal Stand.choices.keys, new_stand.available_choices(users(:user)).keys

    retract
    new_stand = proposition(:solution1).stands.new
    assert_equal Stand.choices.keys - ["retract"], new_stand.available_choices(users(:user)).keys
  end

  def in_favor
    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'in_favor' })
  end

  def oppose
    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'oppose' })
  end

  def retract
    post proposition_stands_path(proposition_id: proposition(:solution1),
                                 stand: { choice: 'retract' })
  end

  def fetch_current_stand
    proposition(:solution1).fetch_stand(users(:user))
  end
end
