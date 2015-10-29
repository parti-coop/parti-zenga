class Proposition < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
  has_many :stands
  include Statusable

  def stand(user)
    stands.current.find_by(user: user)
  end

  def count_stands(choice)
    stands.try(choice).current.count
  end
end
