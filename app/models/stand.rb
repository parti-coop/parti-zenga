class Stand < ActiveRecord::Base
  include Statusable
  include RelatedLinkable

  belongs_to :proposition
  belongs_to :user
  has_one :previous, class_name: :Stand, foreign_key: :previous_id
  has_one :issue, :through => :proposition
  has_many :related_links, as: :source
  has_many :links, through: :related_links

  attr_accessor :has_description
  enum choice: { in_favor: 1, oppose: 2, block: 3, abstain: 4, retract: 5 }

  scope :current, -> { where(current: true) }

  validates :choice, presence: true
  validate :choice_cannot_be_same_with_previous

  before_create :active_current
  before_create :deactive_previous
  before_create :check_description
  after_create :increase_proposition_stands_count

  def available_choices(user)
    result = self.class.choices
    proposition.fetch_stand(user).try(:retract?) ? result.except('retract') : result
  end

  def linkable_contents
    description
  end

  private
  def active_current
    self.current = true
  end

  def check_description
    self.description = nil if self.has_description == "0"
  end

  def deactive_previous
    if self.previous.present?
      self.previous.current = false
      self.previous.save!
    end
  end

  def choice_cannot_be_same_with_previous
    if previous.try(:choice) == choice
      errors.add(:choice, "should be different from previous choice.")
    end
  end

  def increase_proposition_stands_count
    unless self.previous.present?
      self.proposition.stands_count += 1
      self.proposition.save!
    end
  end
end
