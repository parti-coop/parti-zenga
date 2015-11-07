class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url, lenght: 500, null: false, index: true, unique: true
      t.text :title
      t.text :description
      t.text :image
      t.timestamps null: false
    end
  end
end
