class CreateStands < ActiveRecord::Migration
  def change
    create_table :stands do |t|
      t.integer :choice, null: false
      t.boolean :current, default: true
      t.references :previous
      t.references :proposition, null: false, index: true
      t.references :user, null: false, index: true
      t.timestamps null: false
    end
  end
end
