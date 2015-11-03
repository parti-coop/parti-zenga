class AddRelatedPropositionToIssues < ActiveRecord::Migration
  def change
    add_reference :issues, :related_proposition, index: true
  end
end
