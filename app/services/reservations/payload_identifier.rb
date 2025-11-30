module Reservations
  class PayloadIdentifier
    def self.call(payload)
      new(payload).call
    end

    def initialize(payload)
      @payload = payload.deep_symbolize_keys
    end

    def call
      return :format_1 if @payload.key?(:guest)
      return :format_2 if @payload.key?(:reservation)
      
      raise "Unsupported payload format"
    end
  end
end
