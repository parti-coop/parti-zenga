require 'test_helper'

class PropositionsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create porposition" do
    log_in_as_user

    get new_issue_proposition_path issue_id: issue(:one)
    assert_response :success

    post issue_propositions_path(issue_id: issue(:one),
                                 proposition: { title: 'solution1' })
    assert_redirected_to issue_path(issue(:one))

    assert_equal assigns(:proposition).title, 'solution1'
    assert_equal assigns(:proposition).user, users(:user)
    assert_equal assigns(:proposition).status.source, assigns(:proposition)
  end

  test "related proposition" do
    assert_nil Issue.find(issue(:one).id).related_proposition
  end

  test "anonymous user cannot create a porposition" do
    get new_issue_proposition_path issue_id: issue(:one)
    follow_redirect!
    assert_equal new_user_session_path, path
  end
end
