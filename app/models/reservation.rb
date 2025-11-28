
class Reservation < ApplicationRecord
  belongs_to :guest

  ALLOWED_STATUSES = %w[
    accepted
    cancelled
    pending
  ].freeze

  ALLOWED_CURRENCIES = %w[
    AUD
    USD
  ].freeze

  validates :adults,
            :children,
            :currency,
            :end_date,
            :guest_count,
            :infants,
            :nights,
            :payout_price,
            :security_price,
            :start_date,
            :status,
            :total_price,
            presence: true

  # Adults must be at least 1
  validates :adults,
            :guest_count,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1
            }

  # Included nights >= 0 in case same day checkout will be supported in the future.
  validates :children,
            :infants,
            :nights,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :status,
            inclusion: {
              in: ALLOWED_STATUSES,
              message: "must be one of: #{ALLOWED_STATUSES.join(', ')}"
            }

   validates :currency,
            inclusion: {
              in: ALLOWED_CURRENCIES,
              message: "must be one of: #{ALLOWED_CURRENCIES.join(', ')}"
            }
end
