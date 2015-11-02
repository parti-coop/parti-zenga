class AddDescriptionToStands < ActiveRecord::Migration
  def change
    add_column :stands, :description, :text
  end
end
