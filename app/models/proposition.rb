class Proposition < ActiveRecord::Base
  include Statusable

  belongs_to :issue
  belongs_to :user
  has_many :stands
  has_many :related_issues, class_name: Issue, foreign_key: :related_proposition_id
  has_many :related_links
  has_many :links, through: :related_links
  has_many :statuses, foreign_key: :proposition_id

  scope :sort, ->(order_method) { order_method ||= :hottest; try(order_method.to_sym).order(id: :desc) }
  scope :hottest, -> { order(stands_count: :desc) }
  scope :latest, -> { order(created_at: :desc) }

  def fetch_stand(user)
    stands.current.find_by(user: user)
  end

  def stands_count_by(choice)
    stands.try(choice).current.count
  end

  def has_stands?
    stands.current.any?
  end

  def stands_count_as_percent(choice)
    return 0 if stands_count_by(choice) == 0
    stands_count_by(choice).to_f / issue.max_stands_count_in_propositions * 100
  end

  def stated_proposition
    self
  end
end
