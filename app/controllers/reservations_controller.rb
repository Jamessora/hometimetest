class ReservationsController < ApplicationController
  def create
    reservation = Reservations::CreateReservation.call(request_payload)

    render json: ReservationSerializer.new(reservation).serializable_hash, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def request_payload
    request.request_parameters
  end
end
