class AddStandsCountToPropositions < ActiveRecord::Migration
  def change
    add_column :propositions, :stands_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        Proposition.all.each do |proposition|
          proposition.stands_count = Stand.current.where(proposition: proposition).count
          proposition.save!
        end
      end
    end
  end
end
