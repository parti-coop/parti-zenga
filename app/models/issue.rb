class Issue < ActiveRecord::Base
  has_many :propositions
  has_many :comments
end
