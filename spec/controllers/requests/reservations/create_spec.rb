# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /reservations', type: :request do
  subject(:perform_request) do
    post '/reservations', params: params, as: :json
  end

  let(:params) { payload }

  context 'when reservation is created successfully with format 1 payload' do
    let(:payload) { reservation_payload_format1 }

    let(:reservation) { build_stubbed(:reservation) }

    before do
      allow(Reservations::CreateReservation)
        .to receive(:call)
        .and_return(reservation)
    end

    it 'calls the service with the request payload' do
      perform_request

      expected_payload = payload.deep_stringify_keys

      expect(Reservations::CreateReservation)
        .to have_received(:call)
        .with(hash_including(expected_payload))
    end

    it 'returns serialized reservation JSON with status created' do
      perform_request

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to be_present
      expect(body[:data][:id]).to eq(reservation.id.to_s)
      expect(body[:data][:type]).to eq("reservation")
      expect(body[:data][:attributes]).to include(
        guest_id: reservation.guest_id,
        currency: reservation.currency,
        status:   reservation.status
      )
    end
  end

   context 'when reservation is created successfully with format 2 payload' do
    let(:payload) { reservation_payload_format2 }

    let(:reservation) { build_stubbed(:reservation) }

    before do
      allow(Reservations::CreateReservation)
        .to receive(:call)
        .and_return(reservation)
    end

    it 'calls the service with the request payload' do
      perform_request

      expected_payload = payload

      expect(Reservations::CreateReservation)
        .to have_received(:call)
        .with(hash_including(expected_payload))
    end

    it 'returns serialized reservation JSON with status created' do
      perform_request

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to be_present
      expect(body[:data][:id]).to eq(reservation.id.to_s)
      expect(body[:data][:type]).to eq('reservation')
      expect(body[:data][:attributes]).to include(
        guest_id: reservation.guest_id,
        currency: reservation.currency,
        status:   reservation.status
      )
    end
  end

  context 'when ActiveRecord::RecordInvalid is raised' do
    let(:payload) do
      { start_date: nil }
    end

    let(:invalid_record) do
      Reservation.new.tap do |record|
        record.errors.add(:base, 'is invalid')
      end
    end

    before do
      error = ActiveRecord::RecordInvalid.new(invalid_record)

      allow(Reservations::CreateReservation)
        .to receive(:call)
        .and_raise(error)
    end

    it 'returns 422 with validation errors' do
      perform_request

      expect(response).to have_http_status(:unprocessable_content)

      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:errors]).to eq(['is invalid'])
    end
  end

  context 'when an unexpected error occurs' do
    let(:payload) do
      { start_date: '2021-03-12' }
    end

    before do
      allow(Reservations::CreateReservation)
        .to receive(:call)
        .and_raise(StandardError, 'Something went wrong')
    end

    it 'returns 422 with error message' do
      perform_request

      expect(response).to have_http_status(:unprocessable_content)

      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:error]).to eq('Something went wrong')
    end
  end
end
