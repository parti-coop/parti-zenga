class Stand < ActiveRecord::Base
  belongs_to :proposition
  belongs_to :user
  has_one :previous, class_name: :Stand, foreign_key: :previous_id
  has_one :issue, :through => :proposition
  include Statusable

  enum choice: { in_favor: 1, oppose: 2, block: 3, abstain: 4, retract: 5 }

  scope :current, -> { where(current: true) }

  validate :choice_cannot_be_same_with_previous

  before_create :active_current
  after_create :deactive_previous

  def available_choices(user)
    result = self.class.choices
    proposition.stand(user).try(:retract?) ? result.except('retract') : result
  end

  private
    def active_current
      current = true
    end

    def deactive_previous
      if previous.present?
        previous.current = false
        previous.save!
      end
    end

    def choice_cannot_be_same_with_previous
      if previous.try(:choice) == choice
        errors.add(:choice, "should be different from previous choice.")
      end
    end
end
