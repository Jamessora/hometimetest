class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy
  
  validates :email, :first_name, :last_name, :phone_numbers, 
            presence: true

  validates :phone_numbers,
            length: { minimum: 1 }

  validates :email,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
