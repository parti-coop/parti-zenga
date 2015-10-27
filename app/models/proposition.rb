class Proposition < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
  include Statusable
end
