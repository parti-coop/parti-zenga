require 'test_helper'

class PropositionTest < ActiveSupport::TestCase
  fixtures :all

  test "percent" do
    uids = [:user, :rest515, :jaygoon]
    uids.each do |uid|
      proposition(:solution1).stands.create(user: users(uid), choice: Stand.choices[:in_favor])
    end

    issue = proposition(:solution1).issue
    base = issue.max_stands_count_in_propositions
    assert_equal uids.size.to_f / base * 100, proposition(:solution1).stands_count_as_percent(:in_favor)
  end
end
