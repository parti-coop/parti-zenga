class CreatePropositions < ActiveRecord::Migration
  def change
    create_table :propositions do |t|
      t.string :title, null: false
      t.references :issue, null: false
      t.timestamps null: false
    end
  end
end
