class AddPropositionToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :proposition, index: true
  end
end
