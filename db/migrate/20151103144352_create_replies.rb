class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :contents, null: false
      t.references :status, null: false, index: true
      t.references :user, null: false, index: true
      t.timestamps null: false
    end
  end
end
