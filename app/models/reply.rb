class Reply < ActiveRecord::Base
  belongs_to :status
  belongs_to :user

  validates :contents, presence: true
end
