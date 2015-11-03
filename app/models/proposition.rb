class Proposition < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
  has_many :stands
  has_many :related_issues, class_name: Issue, foreign_key: :related_proposition_id
  include Statusable

  def fetch_stand(user)
    stands.current.find_by(user: user)
  end

  def count_stands(choice)
    stands.try(choice).current.count
  end
end
