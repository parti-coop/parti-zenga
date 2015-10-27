require 'test_helper'

class PropositionsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create porposition" do
    log_in_as_user

    get new_issue_proposition_path issue_id: issue_one
    assert_response :success

    post issue_propositions_path,
         issue_id: issue_one, proposition: { title: 'solution1' }
    assert_redirected_to issue_path(issue_one)

    assert_equal assigns(:proposition).title, 'solution1'
  end

  test "anonymous user cannot create a porposition" do
    get new_issue_proposition_path issue_id: issue_one
    follow_redirect!
    assert_equal new_user_session_path, path
  end

  def issue_one
    Issue.find_by title: 'one'
  end
end
