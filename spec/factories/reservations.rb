# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    association :guest

    start_date     { Date.parse('2021-03-12') }
    end_date       { Date.parse('2021-03-16') }
    nights         { 4 }

    currency       { 'AUD' }
    payout_price   { 3800.00 }
    security_price { 500.00 }
    total_price    { 4500.00 }

    status         { 'accepted' }
    adults         { 2 }
    children       { 2 }
    infants        { 0 }
    guest_count    { 4 }
  end
end
