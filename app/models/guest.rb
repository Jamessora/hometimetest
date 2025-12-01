# frozen_string_literal: true

class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  validates :first_name, :last_name,
            presence: true,
            format: {
              with: /\A[\p{L}\s'-]+\z/,
              allow_blank: true,
              message: "may only contain letters, spaces, hyphens, and apostrophes"
            }

  validate :phone_numbers_present

  private

  def phone_numbers_present
     return if phone_numbers.present? && phone_numbers.any?(&:present?)

    errors.add(:phone_numbers, "must include at least one phone number")
  end
end
