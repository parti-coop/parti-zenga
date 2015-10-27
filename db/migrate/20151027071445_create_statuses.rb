class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :issue, null: false, index: true
      t.references :source, polymorphic: true, null: false, index: true
      t.timestamps null: false
    end
  end
end
