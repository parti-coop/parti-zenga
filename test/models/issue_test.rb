require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  fixtures :all

  test "fork" do
    copy = issue(:one).fork

    assert_equal issue(:one).title, copy.title
    assert_equal issue(:one).created_at, copy.created_at
    assert_nil copy.updated_at
    assert_equal issue(:one).propositions.count, issue(:one).propositions.size

    original_proposition = issue(:one).propositions[0]
    copy_proposition = copy.propositions[0]
    assert_equal original_proposition.title, copy_proposition.title
    assert_equal original_proposition.created_at, copy_proposition.created_at
    assert_equal original_proposition.updated_at, copy_proposition.updated_at
    assert_equal original_proposition.user, copy_proposition.user
    assert_equal 0, copy_proposition.stands.size

    assert_equal copy, copy_proposition.issue

    original_proposition_status = issue(:one).propositions[0].status
    copy_proposition_status = copy_proposition.status

    assert_equal copy, copy_proposition_status.issue
    assert_equal copy_proposition, copy_proposition_status.proposition
    assert_equal copy_proposition, copy_proposition_status.source

    copy_reply = copy_proposition_status.replies[0]

    assert_equal copy_proposition_status, copy_reply.status

    original_comment = issue(:one).comments[1]
    copy_comment = copy.comments[1]

    assert_equal copy, copy_comment.issue
    assert_equal copy_proposition, copy_comment.proposition

    assert_equal copy_comment, copy_comment.related_links[0].source
    assert_equal copy, copy_comment.related_links[0].issue
    assert_equal copy_proposition, copy_comment.related_links[0].proposition

    original_reply = original_proposition_status.replies[0]

    assert_equal original_reply.related_links[0].link, copy_reply.related_links[0].link
    assert_equal copy_reply, copy_reply.related_links[0].source
    assert_equal copy, copy_reply.related_links[0].issue
    assert_equal copy_proposition, copy_reply.related_links[0].proposition
  end
end
