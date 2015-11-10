require 'test_helper'

class IssuesTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create issue" do
    log_in_as_user
    get new_issue_path
    assert_response :success

    post issues_path(issue: { title: 'three' })
    assert_equal users(:user), assigns(:issue).user
    assert_redirected_to issue_path(assigns(:issue))
  end

  test "create issue with related proposition" do
    log_in_as_user

    post issues_path(issue: { title: 'four', related_proposition_id: proposition(:solution1) })
    assert_equal proposition(:solution1), assigns(:issue).related_proposition
  end

  test "anonymous user cannot create a issue" do
    get new_issue_path
    follow_redirect!
    assert_equal new_user_session_path, path
  end

  test "fork" do
    log_in_as_user

    fixture = issue(:one)

    # puts "fixture=================="
    # fixture.propositions.each do |p|
    #   pp p.title
    #   pp p.related_links
    # end

    fixture.related_proposition = proposition(:solution2)
    fixture.save!

    Timecop.freeze(Date.today + 30) do
      post fork_issue_path(id: fixture)
    end

    assert_equal issue(:one).title, assigns(:copy).title
    assert_equal issue(:one).created_at, assigns(:copy).created_at
    assert_not_equal issue(:one).updated_at, assigns(:copy).updated_at
    assert_equal issue(:one), assigns(:copy).parent_issue
    # origin = issue(:one).reload
    # copy = assigns(:copy).reload

    # pp origin.comments
    # pp copy.comments
    # pp origin.statuses
    # pp copy.statuses
    # pp origin.propositions
    # pp copy.propositions
    # pp origin.related_proposition
    # pp copy.related_proposition

    # puts "origin==================="
    # origin.statuses.each do |s|
    #   s.replies.each do |r|
    #     pp r
    #     pp r.related_links[0].link
    #   end
    # end
    # puts "copy====================="
    # copy.statuses.each do |s|
    #   s.replies.each do |r|
    #     pp r
    #     pp r.related_links[0].link
    #   end
    # end
    # puts "copy====================="
    # copy.propositions.each do |p|
    #   pp p.stands
    # end
    # puts "origin==================="
    # origin.propositions.each do |p|
    #   pp p.title
    #   pp p.related_links
    # end
    # puts "copy====================="
    # copy.propositions.each do |p|
    #   pp p.title
    #   pp p.related_links
    # end
    # puts "origin==================="
    # origin.propositions.each do |p|
    #   pp p.title
    #   pp p.links.map &:url
    # end
    # puts "copy====================="
    # copy.propositions.each do |p|
    #   pp p.title
    #   pp p.links.map &:url
    # end
    # puts "origin==================="
    # origin.propositions.each do |p|
    #   pp p.title
    #   pp p.statuses.map &:source
    # end
    # puts "copy====================="
    # copy.propositions.each do |p|
    #   pp p.title
    #   pp p.statuses.map &:source
    # end
  end
end
