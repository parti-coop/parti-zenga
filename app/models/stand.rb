class Stand < ActiveRecord::Base
  include Statusable

  belongs_to :proposition
  belongs_to :user
  has_one :previous, class_name: :Stand, foreign_key: :previous_id
  has_one :issue, :through => :proposition
  attr_accessor :has_description
  enum choice: { in_favor: 1, oppose: 2, block: 3, abstain: 4, retract: 5 }

  scope :current, -> { where(current: true) }

  validates :choice, presence: true
  validate :choice_cannot_be_same_with_previous

  before_create :active_current
  before_create :check_description
  after_create :deactive_previous

  def available_choices(user)
    result = self.class.choices
    proposition.fetch_stand(user).try(:retract?) ? result.except('retract') : result
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
end