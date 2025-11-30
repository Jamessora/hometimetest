module Reservations
  module Parsers
    class Format1
      def self.call(payload)
        new(payload).call
      end

      def initialize(payload)
        @data = payload.deep_symbolize_keys
      end

      def call
        {
          guest: {
            email:         @data.dig(:guest, :email),
            first_name:    @data.dig(:guest, :first_name),
            last_name:     @data.dig(:guest, :last_name),
            phone_numbers: [@data.dig(:guest, :phone)]
          },
          reservation: {
            adults:         @data[:adults],
            children:       @data[:children] || 0,
            currency:       @data[:currency],
            guest_count:    @data[:guests],
            infants:        @data[:infants]  || 0,
            nights:         @data[:nights],
            payout_price:   @data[:payout_price],
            security_price: @data[:security_price],
            status:         @data[:status],
            total_price:    @data[:total_price],
            start_date:     @data[:start_date],
            end_date:       @data[:end_date]
          }
        }
      end
    end
  end
end
