class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
  belongs_to :proposition
  include Statusable
end
