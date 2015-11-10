class AddParentIssueToIssues < ActiveRecord::Migration
  def change
    add_reference :issues, :parent_issue, index: true
  end
end
