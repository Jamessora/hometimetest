module Reservations
  module Parsers
    class Format2
      def self.call(payload)
        new(payload).call
      end

      def initialize(payload)
        @data = payload.deep_symbolize_keys[:reservation]
      end

      def call
        {
          guest: {
            email:         @data[:guest_email],
            first_name:    @data[:guest_first_name],
            last_name:     @data[:guest_last_name],
            phone_numbers: Array(@data[:guest_phone_numbers])
          },
          reservation: {
            adults:         @data.dig(:guest_details, :number_of_adults),
            children:       @data.dig(:guest_details, :number_of_children) || 0,
            currency:       @data[:host_currency],
            guest_count:    @data[:number_of_guests],
            infants:        @data.dig(:guest_details, :number_of_infants)  || 0,
            nights:         @data[:nights],
            payout_price:   @data[:expected_payout_amount],
            security_price: @data[:listing_security_price_accurate],
            status:         @data[:status_type],
            total_price:    @data[:total_paid_amount_accurate],
            start_date:     @data[:start_date],
            end_date:       @data[:end_date]
          }
        }
      end
    end
  end
end
