class AddPropositionToStatuses < ActiveRecord::Migration
  def change
    add_reference :statuses, :proposition, index: true

    reversible do |dir|
      dir.up do
        Issue.all.each do |issue|
          issue.statuses.each do |status|
            status.proposition = status.source.stated_proposition
            status.save!
          end
        end
      end
    end
  end
end
