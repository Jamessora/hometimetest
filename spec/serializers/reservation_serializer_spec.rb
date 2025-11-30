require 'rails_helper'

describe ReservationSerializer do
  subject do
    described_class.new(reservation).serializable_hash
  end

  let(:reservation) do
    create(
      :reservation,
      payout_price:   3800.0,
      security_price: 500.0,
      total_price:    4500.0
    )
  end

  it 'serializes the reservation with correct type and id' do
    expect(subject[:data][:type]).to eq(:reservation)
    expect(subject[:data][:id]).to eq(reservation.id.to_s)
  end

  it 'serializes the core attributes' do
    attrs = subject[:data][:attributes]

    expect(attrs[:guest_id]).to eq(reservation.guest_id)
    expect(attrs[:start_date]).to eq(reservation.start_date)
    expect(attrs[:end_date]).to eq(reservation.end_date)
    expect(attrs[:nights]).to eq(reservation.nights)
    expect(attrs[:currency]).to eq(reservation.currency)
    expect(attrs[:status]).to eq(reservation.status)
    expect(attrs[:guest_count]).to eq(reservation.guest_count)
  end

  it 'formats monetary fields as strings with two decimal places' do
    attrs = subject[:data][:attributes]

    expect(attrs[:payout_price]).to   eq('3800.00')
    expect(attrs[:security_price]).to eq('500.00')
    expect(attrs[:total_price]).to    eq('4500.00')
  end
end
