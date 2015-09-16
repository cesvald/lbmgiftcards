class GiftCard < ActiveRecord::Base

  belongs_to :user
  belongs_to :company

  validates_presence_of :user, :code, :value, :company
  
  validates :value, numericality: { only_integer: true }, allow_blank: true

  after_initialize :set_initial_code
  before_validation :parameterize_code

  scope :expired, ->() { where("gift_cards.expiration_date < ? AND state = ?", Date.today, 'pending') }
  scope :last_gift_cards, ->(last) { GiftCard.last(last) }

  state_machine initial: :pending do

    state :pending
    state :redeemed
    state :invalid
    state :expired

    event :redeem do
      transition [:pending] => :redeemed
    end

    event :invalidate do
      transition [:pending] => :invalid
    end

    event :expire do
      transition [:pending] => :expired
    end
  end

  def to_param
    self.code
  end

  private

  def set_initial_code
    company_code = ""
    if self.company.present?
      company_code = self.company.code
    else
      company_code = Company.first.nil? ? "" : Company.first.code
    end
    self.code = "#{company_code}-#{SecureRandom.hex(3)}" unless self.code.present?
  end

  def parameterize_code
    self.code = self.code.parameterize
  end
end