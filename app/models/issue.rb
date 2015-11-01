class Issue < ActiveRecord::Base
  has_many :propositions
  has_many :statuses
  has_many :comments
  belongs_to :user

  default_scope { order(id: :desc) }
end
