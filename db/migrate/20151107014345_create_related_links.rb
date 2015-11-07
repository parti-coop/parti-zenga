class CreateRelatedLinks < ActiveRecord::Migration
  def change
    create_table :related_links do |t|
      t.references :issue, null: false, index: true
      t.references :link, null: false, index: true
      t.references :source, polymorphic: true, null: false, index: true
    end

    add_index :related_links, [:source_id, :link_id], unique: true
  end
end
